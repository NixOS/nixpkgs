{
  pkgs,
  ...
}:

pkgs.testers.nixosTest {
  name = "felix86";

  nodes.machine =
    {
      config,
      pkgs,
      ...
    }:
    {
      boot.binfmt.emulatedSystems = [ "riscv64-linux" ];

      environment.systemPackages = [
        pkgs.pkgsCross.riscv64.felix86
      ];
    };

  testScript =
    # python
    ''
      machine.wait_for_unit("multi-user.target")
      machine.succeed("felix86 --help")
    '';

  interactive.nodes.machine = {
    virtualisation.graphics = false;
    environment.systemPackages = [ pkgs.binutils ];
  };
  interactive.sshBackdoor.enable = true;
}
