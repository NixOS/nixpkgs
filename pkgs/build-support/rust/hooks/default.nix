{
  cargo-nextest,
  clang,
  diffutils,
  lib,
  makeSetupHook,
  rust,
  stdenv,
  pkgsHostTarget,
  pkgsTargetTarget,

  # This confusingly-named parameter indicates the *subdirectory of
  # `target/` from which to copy the build artifacts.  It is derived
  # from a stdenv platform (or a JSON file).
  target ? stdenv.targetPlatform.rust.cargoShortTarget,
  tests,
  pkgsCross,
}:
{
  cargoBuildHook = makeSetupHook {
    name = "cargo-build-hook.sh";
    substitutions = {
      inherit (stdenv.targetPlatform.rust) rustcTargetSpec;
      inherit (rust.envVars) setEnv;

    };
    passthru.tests = {
      test = tests.rust-hooks.cargoBuildHook;
    }
    // lib.optionalAttrs (stdenv.isLinux) {
      testCross = pkgsCross.riscv64.tests.rust-hooks.cargoBuildHook;
    };
  } ./cargo-build-hook.sh;

  cargoCheckHook = makeSetupHook {
    name = "cargo-check-hook.sh";
    substitutions = {
      inherit (stdenv.targetPlatform.rust) rustcTargetSpec;
      inherit (rust.envVars) setEnv;
    };
    passthru.tests = {
      test = tests.rust-hooks.cargoCheckHook;
    }
    // lib.optionalAttrs (stdenv.isLinux) {
      testCross = pkgsCross.riscv64.tests.rust-hooks.cargoCheckHook;
    };
  } ./cargo-check-hook.sh;

  cargoInstallHook = makeSetupHook {
    name = "cargo-install-hook.sh";
    substitutions = {
      targetSubdirectory = target;
    };
    passthru.tests = {
      test = tests.rust-hooks.cargoInstallHook;
    }
    // lib.optionalAttrs (stdenv.isLinux) {
      testCross = pkgsCross.riscv64.tests.rust-hooks.cargoInstallHook;
    };
  } ./cargo-install-hook.sh;

  cargoNextestHook = makeSetupHook {
    name = "cargo-nextest-hook.sh";
    propagatedBuildInputs = [ cargo-nextest ];
    substitutions = {
      inherit (stdenv.targetPlatform.rust) rustcTargetSpec;
    };
    passthru.tests = {
      test = tests.rust-hooks.cargoNextestHook;
    }
    // lib.optionalAttrs (stdenv.isLinux) {
      testCross = pkgsCross.riscv64.tests.rust-hooks.cargoNextestHook;
    };
  } ./cargo-nextest-hook.sh;

  cargoSetupHook = makeSetupHook {
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
          "rustflags" = [ ${
            lib.concatStringsSep ", " (
              [
                ''"-Ctarget-feature=${if stdenv.targetPlatform.isStatic then "+" else "-"}crt-static"''
              ]
              ++ lib.optional (!stdenv.targetPlatform.isx86_32) ''"-Cforce-frame-pointers=yes"''
            )
          } ]
        ''
        + ''
          [target."${stdenv.hostPlatform.rust.rustcTarget}"]
          "linker" = "${stdenv.cc}/bin/${stdenv.cc.targetPrefix}cc"
          "rustflags" = [ ${
            lib.optionalString (!stdenv.hostPlatform.isx86_32) ''"-Cforce-frame-pointers=yes"''
          } ]
        '';
    };

    passthru.tests = {
      test = tests.rust-hooks.cargoSetupHook;
    }
    // lib.optionalAttrs (stdenv.isLinux) {
      testCross = pkgsCross.riscv64.tests.rust-hooks.cargoSetupHook;
    };
  } ./cargo-setup-hook.sh;

  maturinBuildHook = makeSetupHook {
    name = "maturin-build-hook.sh";
    propagatedBuildInputs = [
      pkgsHostTarget.maturin
      pkgsHostTarget.cargo
      pkgsHostTarget.rustc
    ];
    substitutions = {
      inherit (stdenv.targetPlatform.rust) rustcTargetSpec;
      inherit (rust.envVars) setEnv;

    };
  } ./maturin-build-hook.sh;

  bindgenHook = makeSetupHook {
    name = "rust-bindgen-hook";
    substitutions = {
      libclang = (lib.getLib clang.cc);
      inherit clang;
    };
  } ./rust-bindgen-hook.sh;
}
