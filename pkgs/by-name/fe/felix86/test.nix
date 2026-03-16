# Run with:
#   nix-build -A pkgsCross.riscv64.felix86.passthru.tests

{
  pkgs,
  ...
}:

pkgs.testers.nixosTest {
  name = "felix86";

  # FIX:
  # generate-driver-symbols: line 3: syntax error near unexpected token `lambda'
  skipTypeCheck = true;

  nodes.machine =
    {
      pkgs,
      ...
    }:
    {
      nixpkgs.crossSystem.system = "riscv64-linux";

      # grub depends on Perl, which fails to build
      boot.loader.systemd-boot.enable = true;

      # /build/.attr-0l2nkwhif96f51f4amnlf414lhl4rv9vh8iffyp431v6s28gsr90: line 1: /nix/store/xgll7lrnl7l7q5p43lb3nn9y760gp9qh-xxd-tinyxxd-riscv64-unknown-linux-gnu-1.3.10/bin/xxd: cannot execute binary file: Exec format error
      environment.stub-ld.enable = false;

      programs.felix86.enable = true;
      programs.felix86.rootfs =
        (pkgs.pkgsCross.gnu64.buildFHSEnv {
          name = "felix86-rootfs";
          targetPkgs = pkgs: [
            pkgs.bash
            pkgs.coreutils
          ];
        }).fhsenv;
    };

  testScript =
    # python
    ''
      machine.wait_for_unit("multi-user.target")
      machine.succeed("felix86 --help")
    '';
}
