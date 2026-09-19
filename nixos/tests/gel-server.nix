# Gel database server: boot with a file-provided admin password,
# authenticate over TCP, and run a query. No trust-auth anywhere.
{pkgs, ...}: {
  name = "gel-server";

  nodes.machine = {...}: {
    services.gel-server = {
      enable = true;
      passwordFile = pkgs.writeText "gel-test-admin-pw" "test-admin-pw";
    };
    environment.systemPackages = [pkgs.gel];
  };

  testScript = ''
    machine.wait_for_unit("gel-server.service")
    machine.succeed(
        "printf '%s' '{\"host\":\"127.0.0.1\",\"port\":5656,\"user\":\"admin\","
        "\"password\":\"test-admin-pw\",\"branch\":\"main\",\"tls_security\":\"insecure\"}'"
        " > /tmp/creds.json && chmod 600 /tmp/creds.json"
    )
    # First boot compiles the standard library; allow several minutes.
    machine.wait_until_succeeds(
        "gel --credentials-file /tmp/creds.json --connect-timeout 5s query 'select 1'",
        timeout=900,
    )
    machine.succeed(
        "test \"$(gel --credentials-file /tmp/creds.json query --output-format json 'select 1 + 1')\" = '[2]'"
    )
  '';
}
