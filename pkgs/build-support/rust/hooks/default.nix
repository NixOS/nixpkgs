{
  buildPackages,
  callPackage,
  cargo,
  cargo-nextest,
  clang,
  lib,
  makeSetupHook,
  maturin,
  rust,
  rustc,
  stdenv,

  # This confusingly-named parameter indicates the *subdirectory of
  # `target/` from which to copy the build artifacts.  It is derived
  # from a stdenv platform (or a JSON file).
  target ? stdenv.hostPlatform.rust.cargoShortTarget,
}:

{
  cargoBuildHook = callPackage (
    { }:
    makeSetupHook {
      name = "cargo-build-hook.sh";
      propagatedBuildInputs = [ cargo ];
      substitutions = {
        inherit (rust.envVars) rustHostPlatformSpec setEnv;
      };
    } ./cargo-build-hook.sh
  ) { };

  cargoCheckHook = callPackage (
    { }:
    makeSetupHook {
      name = "cargo-check-hook.sh";
      propagatedBuildInputs = [ cargo ];
      substitutions = {
        inherit (rust.envVars) rustHostPlatformSpec;
      };
    } ./cargo-check-hook.sh
  ) { };

  cargoInstallHook = callPackage (
    { }:
    makeSetupHook {
      name = "cargo-install-hook.sh";
      propagatedBuildInputs = [ ];
      substitutions = {
        targetSubdirectory = target;
      };
    } ./cargo-install-hook.sh
  ) { };

  cargoNextestHook = callPackage (
    { }:
    makeSetupHook {
      name = "cargo-nextest-hook.sh";
      propagatedBuildInputs = [
        cargo
        cargo-nextest
      ];
      substitutions = {
        inherit (rust.envVars) rustHostPlatformSpec;
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
        diff = "${lib.getBin buildPackages.diffutils}/bin/diff";

        cargoConfig = ''
          [target."${stdenv.buildPlatform.rust.rustcTarget}"]
          "linker" = "${rust.envVars.linkerForBuild}"
          ${lib.optionalString (stdenv.buildPlatform.config != stdenv.hostPlatform.config) ''
            [target."${stdenv.hostPlatform.rust.rustcTarget}"]
            "linker" = "${rust.envVars.linkerForHost}"
          ''}
          "rustflags" = [ "-C", "target-feature=${
            if stdenv.hostPlatform.isStatic then "+" else "-"
          }crt-static" ]
        '';
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
        inherit (rust.envVars) rustTargetPlatformSpec setEnv;
      };
    } ./maturin-build-hook.sh
  ) { };

  bindgenHook = callPackage (
    { }:
    makeSetupHook {
      name = "rust-bindgen-hook";
      substitutions = {
        libclang = clang.cc.lib;
        inherit clang;
      };
    } ./rust-bindgen-hook.sh
  ) { };
}
