{ pkgs, ... }:
let
  port = "7745";
in
{
  name = "homebox";
  meta = {
    inherit (pkgs.homebox.meta) maintainers;
  };
  nodes =
    let
      self = {
        simple = {
          services.homebox = {
            enable = true;
            settings = {
              HBOX_WEB_PORT = port;
            };
          };
          system.stateVersion = "25.11";
        };

        postgres = {
          imports = [ self.simple ];
          services.homebox.database.createLocally = true;
        };

        explicitPepper =
          {
            config,
            lib,
            ...
          }:
          let
            inherit (config.services.homebox)
              user
              group
              ;
          in
          {
            systemd.tmpfiles.rules = [
              "d /run/homebox 0700 ${user} ${group}"
              "f /run/homebox/pepper 0400 ${user} ${group} - 0a7524fa7b4555ab793c177557b7b8db6619b47cc0574fb99716315e03b6ddf1d67961ee9bf36b19bef448ed3e530957"
            ];
            imports = [ self.simple ];
            services.homebox = {
              settings = {
                HBOX_AUTH_API_KEY_PEPPER_FILE = "/run/homebox/pepper";
              };
            };
            system.stateVersion = lib.mkForce "26.11";
          };
      };
    in
    self;
  testScript = ''
    def test_homebox(node):
      node.wait_for_unit("homebox.service")
      node.wait_for_open_port(${port})

      node.succeed("curl --fail -X GET 'http://localhost:${port}/'")
      out = node.succeed("curl --fail 'http://localhost:${port}/api/v1/status'")
      assert '"health":true' in out

    test_homebox(simple)
    simple.send_monitor_command("quit")
    simple.wait_for_shutdown()
    test_homebox(postgres)
    test_homebox(explicitPepper)
  '';
}
