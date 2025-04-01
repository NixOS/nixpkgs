import ./make-test-python.nix ({ pkgs, lib, ... }: {
  name = "logiops";
  meta = with pkgs.lib.maintainers; { maintainers = [ ckie ]; };

  nodes = {
    main = { ... }: {
      services.logiops = {
        enable = true;

        settings = {
          devices = [{
            name = "Wireless Mouse MX Master 3";

            smartshift = {
              on = true;
              threshold = 20;
            };

            hiresscroll = {
              hires = true;
              invert = false;
              target = false;
            };

            dpi = 1500;

            buttons = [
              {
                cid = "0x53";
                action = {
                  type = "Keypress";
                  keys = [ "KEY_FORWARD" ];
                };
              }
              {
                cid = "0x56";
                action = {
                  type = "Keypress";
                  keys = [ "KEY_BACK" ];
                };
              }
            ];
          }];
        };
      };
    };
  };

  testScript = ''
    start_all()
    with subtest("main machine should succeed"):
      main.wait_for_unit("logiops.service")
  '';
})
