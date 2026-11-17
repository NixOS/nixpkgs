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
      in
      ''
        machine.start()
        machine.wait_for_unit("multi-user.target")

        with subtest("Check for stub (enabled, initial)"):
            machine.succeed('test -L /${libDir}/${ldsoBasename}')

        with subtest("Try FHS executable"):
            machine.copy_from_host('${test-exec.${pkgs.stdenv.hostPlatform.system}}','test-exec')
            machine.succeed('if test-exec/${exec-name} 2>outfile; then false; else [ $? -eq 127 ];fi')
            machine.succeed('grep -qi nixos outfile')

        with subtest("Disable stub"):
            machine.succeed("/run/booted-system/specialisation/nostub/bin/switch-to-configuration test")

        with subtest("Check for stub (disabled)"):
            machine.fail('test -e /${libDir}/${ldsoBasename}')

        with subtest("Create file in stub location (to be overwritten)"):
            machine.succeed('mkdir -p /${libDir};touch /${libDir}/${ldsoBasename}')

        with subtest("Re-enable stub"):
            machine.succeed("/run/booted-system/bin/switch-to-configuration test")

        with subtest("Check for stub (enabled, final)"):
            machine.succeed('test -L /${libDir}/${ldsoBasename}')
      '';
  }
)
