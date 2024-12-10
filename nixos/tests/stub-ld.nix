import ./make-test-python.nix (
  { lib, pkgs, ... }:
  {
    name = "stub-ld";

    nodes.machine =
      { lib, ... }:
      {
        environment.stub-ld.enable = true;

        specialisation.nostub = {
          inheritParentConfig = true;

          configuration =
            { ... }:
            {
              environment.stub-ld.enable = lib.mkForce false;
            };
        };
      };

    testScript =
      let
        libDir = pkgs.stdenv.hostPlatform.libDir;
        ldsoBasename = lib.last (lib.splitString "/" pkgs.stdenv.cc.bintools.dynamicLinker);

        check32 = pkgs.stdenv.isx86_64;
        pkgs32 = pkgs.pkgsi686Linux;

        libDir32 = pkgs32.stdenv.hostPlatform.libDir;
        ldsoBasename32 = lib.last (lib.splitString "/" pkgs32.stdenv.cc.bintools.dynamicLinker);

        test-exec =
          builtins.mapAttrs
            (
              n: v:
              pkgs.runCommand "test-exec-${n}" { src = pkgs.fetchurl v; } "mkdir -p $out;cd $out;tar -xzf $src"
            )
            {
              x86_64-linux.url = "https://github.com/rustic-rs/rustic/releases/download/v0.6.1/rustic-v0.6.1-x86_64-unknown-linux-gnu.tar.gz";
              x86_64-linux.hash = "sha256-3zySzx8MKFprMOi++yr2ZGASE0aRfXHQuG3SN+kWUCI=";
              i686-linux.url = "https://github.com/rustic-rs/rustic/releases/download/v0.6.1/rustic-v0.6.1-i686-unknown-linux-gnu.tar.gz";
              i686-linux.hash = "sha256-fWNiATFeg0B2pfB5zndlnzGn7Ztl8diVS1rFLEDnSLU=";
              aarch64-linux.url = "https://github.com/rustic-rs/rustic/releases/download/v0.6.1/rustic-v0.6.1-aarch64-unknown-linux-gnu.tar.gz";
              aarch64-linux.hash = "sha256-hnldbd2cctQIAhIKoEZLIWY8H3jiFBClkNy2UlyyvAs=";
            };
        exec-name = "rustic";

        if32 = pythonStatement: if check32 then pythonStatement else "pass";
      in
      ''
        machine.start()
        machine.wait_for_unit("multi-user.target")

        with subtest("Check for stub (enabled, initial)"):
            machine.succeed('test -L /${libDir}/${ldsoBasename}')
            ${if32 "machine.succeed('test -L /${libDir32}/${ldsoBasename32}')"}

        with subtest("Try FHS executable"):
            machine.copy_from_host('${test-exec.${pkgs.stdenv.hostPlatform.system}}','test-exec')
            machine.succeed('if test-exec/${exec-name} 2>outfile; then false; else [ $? -eq 127 ];fi')
            machine.succeed('grep -qi nixos outfile')
            ${if32 "machine.copy_from_host('${
              test-exec.${pkgs32.stdenv.hostPlatform.system}
            }','test-exec32')"}
            ${if32 "machine.succeed('if test-exec32/${exec-name} 2>outfile32; then false; else [ $? -eq 127 ];fi')"}
            ${if32 "machine.succeed('grep -qi nixos outfile32')"}

        with subtest("Disable stub"):
            machine.succeed("/run/booted-system/specialisation/nostub/bin/switch-to-configuration test")

        with subtest("Check for stub (disabled)"):
            machine.fail('test -e /${libDir}/${ldsoBasename}')
            ${if32 "machine.fail('test -e /${libDir32}/${ldsoBasename32}')"}

        with subtest("Create file in stub location (to be overwritten)"):
            machine.succeed('mkdir -p /${libDir};touch /${libDir}/${ldsoBasename}')
            ${if32 "machine.succeed('mkdir -p /${libDir32};touch /${libDir32}/${ldsoBasename32}')"}

        with subtest("Re-enable stub"):
            machine.succeed("/run/booted-system/bin/switch-to-configuration test")

        with subtest("Check for stub (enabled, final)"):
            machine.succeed('test -L /${libDir}/${ldsoBasename}')
            ${if32 "machine.succeed('test -L /${libDir32}/${ldsoBasename32}')"}
      '';
  }
)
