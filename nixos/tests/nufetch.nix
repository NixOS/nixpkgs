{ pkgs, ... }:
{
  name = "nufetch";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ gignsky ];
  };
  nodes.machine = { ... }: {
    environment.systemPackages = [];
    programs.nufetch.enable = true;
    virtualisation.memorySize = 512;
  };

  testScript =
    ''
      start_all()

      machine.wait_for_unit("multi-user.target")

      nufetch_output = machine.succeed("nufetch")
      machine.log(nufetch_output)

      neofetch_output = machine.succeed("neofetch")
      machine.log(neofetch_output)
    '';
}