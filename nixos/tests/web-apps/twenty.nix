{ lib, ... }:
{
  name = "twenty";

  meta.maintainers = with lib.maintainers; [ jfly ];

  containers.server = { config, ... }: {
    systemd.tmpfiles.rules = [
      "d /run/secrets/ 0755 root root -"
      "f /run/secrets/twenty-encryption-key 0600 root root - tUpbsJfDRCmRjVWl0f2VY3wRRHRAJcDiDaqH0ylFmsY="
    ];

    services.twenty = {
      enable = true;
      port = 3042;
      serverUrl = "http://server:${toString config.services.twenty.port}";
      encryptionKeyFile = "/run/secrets/twenty-encryption-key";
      openFirewall = true;
    };
  };

  containers.client = { };

  testScript = { containers, ... }: /* python */ ''
    port = ${toString containers.server.services.twenty.port}
    server_url = "${containers.server.services.twenty.serverUrl}"

    server.wait_for_unit("twenty-server.service")
    server.wait_for_open_port(port)

    client.succeed(f"curl --fail {server_url}/healthz")
  '';
}
