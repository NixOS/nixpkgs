{ pkgs, ... }:
{
  name = "systemd-journal-upload";
  meta = with pkgs.lib.maintainers; {
    maintainers = [
      minijackson
    ];
  };

  # systemd in Nixpkgs is built without GnuTLS, so systemd-journal-remote
  # cannot terminate TLS itself. We put nginx in front of it with mutual TLS
  # and have systemd-journal-upload (which uses curl+openssl) talk HTTPS to
  # nginx. This exercises both the recommended migration path and verifies
  # that journal-upload's TLS support still works.
  nodes.server =
    { lib, nodes, ... }:
    {

      services.journald.remote = {
        enable = true;
        settings.Remote = {
          Seal = true;
        };
      };

      # Keep journal-remote loopback-only; only nginx is exposed to the network.
      systemd.sockets.systemd-journal-remote.listenStreams = lib.mkForce [
        ""
        "127.0.0.1:${toString nodes.server.services.journald.remote.port}"
      ];

      virtualisation.credentials = {
        "ca.cert.pem".source = "./ca.cert.pem";
        "server.cert.pem".source = "./server.cert.pem";
        "server.key.pem".source = "./server.key.pem";
      };
      systemd.services.nginx.serviceConfig.ImportCredential = [
        "server.cert.pem"
        "server.key.pem"
        "ca.cert.pem"
      ];
      services.nginx = {
        enable = true;
        virtualHosts."server" = {
          onlySSL = true;
          http2 = false;
          sslCertificate = "/run/credentials/nginx.service/server.cert.pem";
          sslCertificateKey = "/run/credentials/nginx.service/server.key.pem";
          extraConfig = ''
            ssl_client_certificate /run/credentials/nginx.service/ca.cert.pem;
            ssl_verify_client on;
          '';
          locations."/".proxyPass = "http://127.0.0.1:${toString nodes.server.services.journald.remote.port}";
        };
      };

      networking.firewall.allowedTCPPorts = [ 443 ];
    };

  nodes.client =
    { lib, ... }:
    {
      virtualisation.credentials = {
        "ca.cert.pem".source = "./ca.cert.pem";
        "client.cert.pem".source = "./client.cert.pem";
        "client.key.pem".source = "./client.key.pem";
      };
      systemd.services.systemd-journal-upload.serviceConfig.ImportCredential = [
        "client.cert.pem"
        "client.key.pem"
        "ca.cert.pem"
      ];
      services.journald.upload = {
        enable = true;
        settings.Upload = {
          URL = "https://server:443";
          ServerCertificateFile = "/run/credentials/systemd-journal-upload.service/client.cert.pem";
          ServerKeyFile = "/run/credentials/systemd-journal-upload.service/client.key.pem";
          TrustedCertificateFile = "/run/credentials/systemd-journal-upload.service/ca.cert.pem";
        };
      };
    };

  testScript = ''
    import subprocess
    import tempfile
    import shutil

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

    def copy_pems(machine: BaseMachine, domain: str):
      shutil.copy(f"{tmpdir}/{domain}/cert.pem", machine.state_dir / f"{domain}.cert.pem")
      shutil.copy(f"{tmpdir}/{domain}/key.pem", machine.state_dir / f"{domain}.key.pem")
      shutil.copy(f"{tmpdir}/ca.cert.pem", machine.state_dir / "ca.cert.pem")

    with subtest("Copying keys and certificates"):
      copy_pems(server, "server")
      copy_pems(client, "client")

    server.wait_for_unit("nginx.service")
    client.wait_for_unit("systemd-journal-upload.service")

    identifier = "nixos-test"
    message = "Hello from NixOS test infrastructure"

    client.succeed(f"systemd-cat --identifier={identifier} <<< '{message}'")
    server.wait_until_succeeds(
      f"journalctl --file /var/log/journal/remote/remote-*.journal --identifier={identifier} | grep -F '{message}'"
    )
  '';
}
