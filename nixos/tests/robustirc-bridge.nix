{ pkgs, ... }:

{
  name = "robustirc-bridge";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ hax404 ];
  };

  nodes = {
    bridge = {
      services.robustirc-bridge = {
        enable = true;
        extraFlags = [
          "-listen localhost:6667"
          "-network example.com"
        ];
      };
    };
  };

  testScript = ''
    start_all()

    bridge.wait_for_unit("robustirc-bridge.service")
    bridge.wait_for_open_port(1080)
    bridge.wait_for_open_port(6667)
  '';
}
