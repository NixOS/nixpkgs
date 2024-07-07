import ./make-test-python.nix ({ pkgs, ... }:
{
  name = "systemd-journal-upload";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ minijackson raitobezarius ];
  };

  nodes.server = { nodes, ... }: {
    services.journald.remote = {
      enable = true;
      listen = "http";
      settings.Remote = {
        ServerCertificateFile = "/run/secrets/sever.cert.pem";
        ServerKeyFile = "/run/secrets/sever.key.pem";
        TrustedCertificateFile = "/run/secrets/ca.cert.pem";
        Seal = true;
      };
    };

    networking.firewall.allowedTCPPorts = [ nodes.server.services.journald.remote.port ];
  };

  nodes.client = { lib, nodes, ... }: {
    services.journald.upload = {
      enable = true;
      settings.Upload = {
        URL = "http://server:${toString nodes.server.services.journald.remote.port}";
        ServerCertificateFile = "/run/secrets/client.cert.pem";
        ServerKeyFile = "/run/secrets/client.key.pem";
        TrustedCertificateFile = "/run/secrets/ca.cert.pem";
      };
    };

    # Wait for the PEMs to arrive
    systemd.services.systemd-journal-upload.wantedBy = lib.mkForce [];
    systemd.paths.systemd-journal-upload = {
      wantedBy = [ "default.target" ];
      # This file must be copied last
      pathConfig.PathExists = [ "/run/secrets/ca.cert.pem" ];
    };
  };

  testScript = ''
    import subprocess
    import tempfile

    tmpdir_o = tempfile.TemporaryDirectory()
    tmpdir = tmpdir_o.name

    def generate_pems(domain: str):
      subprocess.run(
        [
          "${pkgs.minica}/bin/minica",
          "--ca-key=ca.key.pem",
          "--ca-cert=ca.cert.pem",
          f"--domains={domain}",
        ],
        cwd=str(tmpdir),
      )

    with subtest("Creating keys and certificates"):
      generate_pems("server")
      generate_pems("client")

    server.wait_for_unit("multi-user.target")
    client.wait_for_unit("multi-user.target")

    def copy_pems(machine: Machine, domain: str):
      machine.succeed("mkdir /run/secrets")
      machine.copy_from_host(
        source=f"{tmpdir}/{domain}/cert.pem",
        target=f"/run/secrets/{domain}.cert.pem",
      )
      machine.copy_from_host(
        source=f"{tmpdir}/{domain}/key.pem",
        target=f"/run/secrets/{domain}.key.pem",
      )
      # Should be last
      machine.copy_from_host(
        source=f"{tmpdir}/ca.cert.pem",
        target="/run/secrets/ca.cert.pem",
      )

    with subtest("Copying keys and certificates"):
      copy_pems(server, "server")
      copy_pems(client, "client")

    client.wait_for_unit("systemd-journal-upload.service")
    # The journal upload should have started the remote service, triggered by
    # the .socket unit
    server.wait_for_unit("systemd-journal-remote.service")

    identifier = "nixos-test"
    message = "Hello from NixOS test infrastructure"

    client.succeed(f"systemd-cat --identifier={identifier} <<< '{message}'")
    server.wait_until_succeeds(
      f"journalctl --file /var/log/journal/remote/remote-*.journal --identifier={identifier} | grep -F '{message}'"
    )
  '';
})
