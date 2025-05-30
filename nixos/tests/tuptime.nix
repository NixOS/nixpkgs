{ pkgs, ... }:
{
  name = "tuptime";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ evils ];
  };

  nodes.machine =
    { pkgs, ... }:
    {
      imports = [ ../modules/profiles/minimal.nix ];
      services.tuptime.enable = true;
    };

  testScript = ''
    # see if it starts
    start_all()
    machine.wait_for_unit("multi-user.target")
    machine.succeed("tuptime | grep 'System startups:[[:blank:]]*1'")
    machine.succeed("tuptime | grep 'System uptime:[[:blank:]]*100.0%'")
    machine.shutdown()

    # restart machine and see if it correctly reports the reboot
    machine.start()
    machine.wait_for_unit("multi-user.target")
    machine.succeed("tuptime | grep 'System startups:[[:blank:]]*2'")
    machine.succeed("tuptime | grep 'System shutdowns:[[:blank:]]*1 ok'")
    machine.shutdown()
  '';
}
