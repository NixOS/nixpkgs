{
  buildPackages,
  callPackage,
  cargo,
  cargo-nextest,
  clang,
  diffutils,
  lib,
  makeSetupHook,
  maturin,
  rust,
  rustc,
  stdenv,
  pkgsTargetTarget,

  # This confusingly-named parameter indicates the *subdirectory of
  # `target/` from which to copy the build artifacts.  It is derived
  # from a stdenv platform (or a JSON file).
  target ? stdenv.targetPlatform.rust.cargoShortTarget,
  tests,
  pkgsCross,
}:
{
  cargoBuildHook = callPackage (
    { }:
    makeSetupHook {
      name = "cargo-build-hook.sh";
      substitutions = {
        inherit (stdenv.targetPlatform.rust) rustcTarget;
        inherit (rust.envVars) setEnv;

      };
      passthru.tests =
        {
          test = tests.rust-hooks.cargoBuildHook;
        }
        // lib.optionalAttrs (stdenv.isLinux) {
          testCross = pkgsCross.riscv64.tests.rust-hooks.cargoBuildHook;
        };
    } ./cargo-build-hook.sh
  ) { };

  cargoCheckHook = callPackage (
    { }:
    makeSetupHook {
      name = "cargo-check-hook.sh";
      substitutions = {
        inherit (stdenv.targetPlatform.rust) rustcTarget;
        inherit (rust.envVars) setEnv;
      };
      passthru.tests =
        {
          test = tests.rust-hooks.cargoCheckHook;
        }
        // lib.optionalAttrs (stdenv.isLinux) {
          testCross = pkgsCross.riscv64.tests.rust-hooks.cargoCheckHook;
        };
    } ./cargo-check-hook.sh
  ) { };

  cargoInstallHook = callPackage (
    { }:
    makeSetupHook {
      name = "cargo-install-hook.sh";
      substitutions = {
        targetSubdirectory = target;
      };
      passthru.tests =
        {
          test = tests.rust-hooks.cargoInstallHook;
        }
        // lib.optionalAttrs (stdenv.isLinux) {
          testCross = pkgsCross.riscv64.tests.rust-hooks.cargoInstallHook;
        };
    } ./cargo-install-hook.sh
  ) { };

  cargoNextestHook = callPackage (
    { }:
    makeSetupHook {
      name = "cargo-nextest-hook.sh";
      propagatedBuildInputs = [ cargo-nextest ];
      substitutions = {
        inherit (stdenv.targetPlatform.rust) rustcTarget;
      };
      passthru.tests =
        {
          test = tests.rust-hooks.cargoNextestHook;
        }
        // lib.optionalAttrs (stdenv.isLinux) {
          testCross = pkgsCross.riscv64.tests.rust-hooks.cargoNextestHook;
        };
    } ./cargo-nextest-hook.sh
  ) { };

  cargoSetupHook = callPackage (
    { }:
    makeSetupHook {
      name = "cargo-setup-hook.sh";
      propagatedBuildInputs = [ ];
      substitutions = {
        defaultConfig = ../fetchcargo-default-config.toml;

        # Specify the stdenv's `diff` by abspath to ensure that the user's build
        # inputs do not cause us to find the wrong `diff`.
        diff = "${lib.getBin diffutils}/bin/diff";

        cargoConfig =
          lib.optionalString (stdenv.hostPlatform.config != stdenv.targetPlatform.config) ''
            [target."${stdenv.targetPlatform.rust.rustcTarget}"]
            "linker" = "${pkgsTargetTarget.stdenv.cc}/bin/${pkgsTargetTarget.stdenv.cc.targetPrefix}cc"
            "rustflags" = [ "-C", "target-feature=${
              if pkgsTargetTarget.stdenv.targetPlatform.isStatic then "+" else "-"
            }crt-static" ]
          ''
          + ''
            [target."${stdenv.hostPlatform.rust.rustcTarget}"]
            "linker" = "${stdenv.cc}/bin/${stdenv.cc.targetPrefix}cc"
          '';
      };
      passthru.tests =
        {
          test = tests.rust-hooks.cargoSetupHook;
        }
        // lib.optionalAttrs (stdenv.isLinux) {
          testCross = pkgsCross.riscv64.tests.rust-hooks.cargoSetupHook;
        };
    } ./cargo-setup-hook.sh
  ) { };

  maturinBuildHook = callPackage (
    { pkgsHostTarget }:
    makeSetupHook {
      name = "maturin-build-hook.sh";
      propagatedBuildInputs = [
        pkgsHostTarget.maturin
        pkgsHostTarget.cargo
        pkgsHostTarget.rustc
      ];
      substitutions = {
        inherit (stdenv.targetPlatform.rust) rustcTarget;
        inherit (rust.envVars) setEnv;

      };
    } ./maturin-build-hook.sh
  ) { };

  bindgenHook = callPackage (
    { }:
    makeSetupHook {
      name = "rust-bindgen-hook";
      substitutions = {
        libclang = (lib.getLib clang.cc);
        inherit clang;
      };
    } ./rust-bindgen-hook.sh
  ) { };
}
