# Run with:
#   NIXPKGS_ALLOW_UNSUPPORTED_SYSTEM=1 nix-build -A felix86.passthru.tests

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

      programs.felix86 = {
        enable = true;
        disableBinfmt = true;
        package = pkgs.pkgsCross.riscv64.felix86;
        rootfs =
          (pkgs.pkgsCross.gnu64.buildFHSEnv {
            name = "felix86-rootfs";
            targetPkgs = pkgs: [
              pkgs.bash
              pkgs.coreutils
            ];
          }).fhsenv;
      };
    };

  testScript =
    # python
    ''
      machine.wait_for_unit("multi-user.target")
      machine.succeed("felix86 --help")
    '';

  interactive.nodes.machine = {
    virtualisation.graphics = false;
    environment.systemPackages = [
      pkgs.binutils
    ];
  };
  interactive.sshBackdoor.enable = true;
}
