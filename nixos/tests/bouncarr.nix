{ lib, ... }:
{
  name = "bouncarr";

  meta.maintainers = [ lib.maintainers.anish ];

  nodes.machine =
    { pkgs, ... }:
    {
      services.bouncarr = {
        enable = true;
        settings = {
          jellyfin = {
            url = "http://127.0.0.1:8096";
            api_key._secret = "/etc/bouncarr-jellyfin-api-key";
          };
          arr_apps = [
            {
              name = "sonarr";
              url = "http://127.0.0.1:8989";
            }
          ];
          server = {
            host = "127.0.0.1";
            port = 3000;
          };
        };
        # Exercise the environmentFile code path.
        environmentFile = "/etc/bouncarr.env";
      };

      environment.etc."bouncarr-jellyfin-api-key".text = "test-api-key";
      environment.etc."bouncarr.env".text = "JWT_SECRET=test-jwt-secret";

      environment.systemPackages = [ pkgs.curl ];
    };

  testScript = ''
    machine.wait_for_unit("bouncarr.service")
    machine.wait_for_open_port(3000)

    # Health endpoint confirms config.yaml loaded and the service is serving.
    machine.succeed(
        "curl -sf http://127.0.0.1:3000/health | grep -q '\"status\":\"ok\"'"
    )

    # Protected *arr routes reject requests without a valid token.
    status = machine.succeed(
        "curl -s -o /dev/null -w '%{http_code}' http://127.0.0.1:3000/sonarr"
    ).strip()
    assert status == "401", f"expected 401 for unauthenticated /sonarr, got {status}"

    # The Jellyfin API key secret must be substituted into config.yaml.
    machine.succeed("grep -q test-api-key /var/lib/bouncarr/config.yaml")
  '';
}
