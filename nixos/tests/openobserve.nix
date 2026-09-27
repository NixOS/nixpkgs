{ lib, ... }:
{
  name = "openobserve";
  meta.maintainers = [ lib.maintainers.kashw2 ];

  nodes.machine =
    { ... }:
    {
      services.openobserve = {
        enable = true;
        openFirewall = true;
        settings = {
          ZO_ROOT_USER_EMAIL = "root@example.com";
          # openobserve requires >=8 chars with lower, upper, digit and special.
          ZO_ROOT_USER_PASSWORD = "Nixpkgs@123";
          ZO_TELEMETRY = false;
        };
      };
    };

  testScript = ''
    machine.wait_for_unit("openobserve.service")
    machine.wait_for_open_port(5080)

    # Health endpoint reports ready.
    machine.wait_until_succeeds("curl -sf http://127.0.0.1:5080/healthz")

    # The configured root user can authenticate and return their org / user object
    machine.succeed(
        "curl -sf -u root@example.com:Nixpkgs@123 http://127.0.0.1:5080/api/organizations"
    )

    # Data lives in the systemd-managed state directory.
    machine.succeed("test -d /var/lib/openobserve")
  '';
}
