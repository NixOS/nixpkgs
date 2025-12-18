{ lib, pkgs, ... }:

{
  name = "peerbanhelper";

  nodes.machine =
    { ... }:
    {
      environment.systemPackages = with pkgs; [
        curl
      ];
      services.peerbanhelper = {
        enable = true;
        port = 9898;
      };
    };

  testScript = ''
    machine.wait_for_unit("peerbanhelper.service")
    machine.wait_for_open_port(9898)
    response = machine.succeed("curl -f http://localhost:9898")
    if "PeerBanHelper" not in response:
      raise Exception("WebUI did not return expected content")
  '';

  meta = {
    maintainers = with lib.maintainers; [ Misaka13514 ];
  };
}
