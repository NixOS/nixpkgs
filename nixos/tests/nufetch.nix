{ pkgs, lib, ... }:
{
  name = "nufetch";
  meta = with lib.maintainers; {
    maintainers = [ gignsky ];
  };
  nodes.machine =
    { ... }:
    {
      environment.systemPackages = [ ];
      programs.nufetch.enable = true;
      virtualisation.memorySize = 512;
    };

  testScript = ''
    start_all()

    machine.wait_for_unit("multi-user.target")

    nufetch_output = machine.succeed("nufetch")
    neofetch_output = machine.succeed("neofetch")
  '';
}
