import ./make-test-python.nix (
  { pkgs, ... }:
  let
    port = "7745";
  in
  {
    name = "homebox";
    meta = with pkgs.lib.maintainers; {
      maintainers = [ patrickdag ];
    };
    nodes.machine = {
      services.homebox = {
        enable = true;
        settings.HBOX_WEB_PORT = port;
      };
    };
    testScript = ''
      machine.wait_for_unit("homebox.service")
      machine.wait_for_open_port(${port})

      machine.succeed("curl --fail -X GET 'http://localhost:${port}/'")
      out = machine.succeed("curl --fail 'http://localhost:${port}/api/v1/status'")
      assert '"health":true' in out
    '';
  }
)
