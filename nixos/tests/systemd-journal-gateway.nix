{ lib, pkgs, ... }:
{
  name = "systemd-journal-gateway";
  meta = with pkgs.lib.maintainers; {
    maintainers = [
      minijackson
      raitobezarius
    ];
  };

  # Named client for coherence with the systemd-journal-upload test, and for
  # certificate validation
  nodes.client = {
    services.journald.gateway = {
      enable = true;
      cert = "/run/secrets/client/cert.pem";
      key = "/run/secrets/client/key.pem";
      trust = "/run/secrets/ca.cert.pem";
    };
  };

  testScript = ''
    import json
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

    client.wait_for_unit("multi-user.target")

    def copy_pem(file: str):
      machine.copy_from_host(source=f"{tmpdir}/{file}", target=f"/run/secrets/{file}")
      machine.succeed(f"chmod 600 /run/secrets/{file} && chown systemd-journal-gateway /run/secrets/{file}")

    with subtest("Copying keys and certificates"):
      machine.succeed("mkdir -p /run/secrets/{client,server}")
      copy_pem("server/cert.pem")
      copy_pem("server/key.pem")
      copy_pem("client/cert.pem")
      copy_pem("client/key.pem")
      copy_pem("ca.cert.pem")

    client.wait_for_unit("multi-user.target")

    curl = '${pkgs.curl}/bin/curl'
    accept_json = '--header "Accept: application/json"'
    cacert = '--cacert /run/secrets/ca.cert.pem'
    cert = '--cert /run/secrets/server/cert.pem'
    key = '--key /run/secrets/server/key.pem'
    base_url = 'https://client:19531'

    curl_cli = f"{curl} {accept_json} {cacert} {cert} {key} --fail"

    machine_info = client.succeed(f"{curl_cli} {base_url}/machine")
    assert json.loads(machine_info)["hostname"] == "client", "wrong machine name"

    # The HTTP request should have started the gateway service, triggered by
    # the .socket unit
    client.wait_for_unit("systemd-journal-gatewayd.service")

    identifier = "nixos-test"
    message = "Hello from NixOS test infrastructure"

    client.succeed(f"systemd-cat --identifier={identifier} <<< '{message}'")

    # max-time is a workaround against a bug in systemd-journal-gatewayd where
    # if TLS is enabled, the connection is never closed. Since it will timeout,
    # we ignore the return code.
    entries = client.succeed(
        f"{curl_cli} --max-time 5 {base_url}/entries?SYSLOG_IDENTIFIER={identifier} || true"
    )

    # Number of entries should be only 1
    added_entry = json.loads(entries)
    assert added_entry["SYSLOG_IDENTIFIER"] == identifier and added_entry["MESSAGE"] == message, "journal entry does not correspond"
  '';
}
