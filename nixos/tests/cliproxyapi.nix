{ lib, ... }:
{
  name = "cliproxyapi";

  meta.maintainers = [ lib.maintainers.anish ];

  nodes.machine =
    { pkgs, ... }:
    {
      services.cliproxyapi = {
        enable = true;
        settings = {
          host = "127.0.0.1";
          port = 8317;
          api-keys = [ { _secret = "/etc/cliproxyapi-api-key"; } ];
        };
      };

      environment.etc."cliproxyapi-api-key".text = "test-key";
      environment.systemPackages = [ pkgs.curl ];
    };

  testScript = ''
    machine.wait_for_unit("cliproxyapi.service")
    machine.wait_for_open_port(8317)

    # The API key secret must be substituted into config.yaml.
    machine.succeed("grep -q test-key /var/lib/cliproxyapi/config.yaml")

    # Requests without a valid API key are rejected.
    status = machine.succeed(
        "curl -s -o /dev/null -w '%{http_code}' http://127.0.0.1:8317/v1/models"
    ).strip()
    assert status == "401", f"expected 401 for unauthenticated /v1/models, got {status}"

    # Requests carrying the configured API key are accepted.
    machine.succeed(
        "curl -sf -H 'Authorization: Bearer test-key' http://127.0.0.1:8317/v1/models"
    )
  '';
}
