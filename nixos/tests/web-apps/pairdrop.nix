{ ... }:
{
  name = "pairdrop-nixos";

  nodes.machine =
    { pkgs, ... }:
    {
      services.pairdrop = {
        enable = true;
        port = 1337;
        environment = {
          SIGNALING_SERVER = "pairdrop.net";
          CUSTOM_BUTTON_ACTIVE = false;
        };
      };
    };

  testScript = ''
    import json

    machine.wait_for_unit("pairdrop.service")

    machine.wait_for_open_port(1337)
    machine.succeed("curl --fail http://localhost:1337/")

    res = machine.succeed("curl --fail http://localhost:1337/config")
    print(res)
    cfg = json.loads(res)
    assert cfg["signalingServer"] == "pairdrop.net/"
    assert cfg["buttons"]["custom_button"]["active"] == "false"
  '';
}
