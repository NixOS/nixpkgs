{ ... }:
{
  name = "localsend";

  nodes.machine =
    { ... }:
    {
      imports = [ ./common/x11.nix ];
      programs.localsend.enable = true;
    };

  testScript = ''
    machine.wait_for_x()
    machine.succeed("localsend_app >&2 &")
    machine.wait_for_open_port(53317)
    machine.wait_for_window("LocalSend", 10)
    machine.succeed("ss --listening --tcp --numeric --processes | grep -P '53317.*localsend'")
    machine.succeed("ss --listening --udp --numeric --processes | grep -P '53317.*localsend'")
  '';
}
