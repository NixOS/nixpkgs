{ pkgs, ... }:
let
  port = "7745";
in
{
  name = "homebox";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ patrickdag ];
  };
  nodes =
    let
      self = {
        simple = {
          services.homebox = {
            enable = true;
            settings.HBOX_WEB_PORT = port;
          };
        };

        postgres = {
          imports = [ self.simple ];
          services.homebox.database.createLocally = true;
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
  '';
}
