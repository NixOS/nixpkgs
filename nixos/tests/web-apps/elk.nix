{ lib, ... }:
{
  name = "elk-zone";

  meta.maintainers = with lib.maintainers; [ onny ];

  nodes.machine =
    { pkgs, ... }:
    {
      services.elk = {
        enable = true;
        settings = {
          PORT = 3000;
          NUXT_PUBLIC_DEFAULT_SERVER = "mastodon.social";
        };
      };
    };

  testScript = ''
    machine.wait_for_unit("elk.service")
    machine.wait_for_open_port(3000)
    machine.succeed("curl --fail http://localhost:3000/")
    machine.succeed(
        "systemctl show elk.service --property=Environment | grep -F 'NUXT_PUBLIC_DEFAULT_SERVER=mastodon.social'"
    )
  '';
}
