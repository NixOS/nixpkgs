{ buildPackages
, callPackage
, cargo
, cargo-nextest
, clang
, lib
, makeSetupHook
, maturin
, rust
, rustc
, stdenv
, target ? rust.toRustTargetSpec stdenv.hostPlatform
}:

let
  targetIsJSON = lib.hasSuffix ".json" target;

  # see https://github.com/rust-lang/cargo/blob/964a16a28e234a3d397b2a7031d4ab4a428b1391/src/cargo/core/compiler/compile_kind.rs#L151-L168
  # the "${}" is needed to transform the path into a /nix/store path before baseNameOf
  shortTarget = if targetIsJSON then
      (lib.removeSuffix ".json" (builtins.baseNameOf "${target}"))
    else target;
  ccForBuild = "${buildPackages.stdenv.cc}/bin/${buildPackages.stdenv.cc.targetPrefix}cc";
  cxxForBuild = "${buildPackages.stdenv.cc}/bin/${buildPackages.stdenv.cc.targetPrefix}c++";
  ccForHost = "${stdenv.cc}/bin/${stdenv.cc.targetPrefix}cc";
  cxxForHost = "${stdenv.cc}/bin/${stdenv.cc.targetPrefix}c++";
  rustBuildPlatform = rust.toRustTarget stdenv.buildPlatform;
  rustTargetPlatform = rust.toRustTarget stdenv.hostPlatform;
  rustTargetPlatformSpec = rust.toRustTargetSpec stdenv.hostPlatform;
in {
  cargoBuildHook = callPackage ({ }:
    makeSetupHook {
      name = "cargo-build-hook.sh";
      propagatedBuildInputs = [ cargo ];
      substitutions = {
        inherit ccForBuild ccForHost cxxForBuild cxxForHost
          rustBuildPlatform rustTargetPlatform rustTargetPlatformSpec;
      };
    } ./cargo-build-hook.sh) {};

  cargoCheckHook = callPackage ({ }:
    makeSetupHook {
      name = "cargo-check-hook.sh";
      propagatedBuildInputs = [ cargo ];
      substitutions = {
        inherit rustTargetPlatformSpec;
      };
    } ./cargo-check-hook.sh) {};

  cargoInstallHook = callPackage ({ }:
    makeSetupHook {
      name = "cargo-install-hook.sh";
      propagatedBuildInputs = [ ];
      substitutions = {
        inherit shortTarget;
      };
    } ./cargo-install-hook.sh) {};

  cargoNextestHook = callPackage ({ }:
    makeSetupHook {
      name = "cargo-nextest-hook.sh";
      propagatedBuildInputs = [ cargo cargo-nextest ];
      substitutions = {
        inherit rustTargetPlatformSpec;
      };
    } ./cargo-nextest-hook.sh) {};

  cargoSetupHook = callPackage ({ }:
    makeSetupHook {
      name = "cargo-setup-hook.sh";
      propagatedBuildInputs = [ ];
      substitutions = {
        defaultConfig = ../fetchcargo-default-config.toml;

        # Specify the stdenv's `diff` by abspath to ensure that the user's build
        # inputs do not cause us to find the wrong `diff`.
        diff = "${lib.getBin buildPackages.diffutils}/bin/diff";

        cargoConfig = ''
          [target."${rust.toRustTarget stdenv.buildPlatform}"]
          "linker" = "${ccForBuild}"
          ${lib.optionalString (stdenv.buildPlatform.config != stdenv.hostPlatform.config) ''
            [target."${shortTarget}"]
            "linker" = "${ccForHost}"
          ''}
          "rustflags" = [ "-C", "target-feature=${if stdenv.hostPlatform.isStatic then "+" else "-"}crt-static" ]
        '';
      };
    } ./cargo-setup-hook.sh) {};

  maturinBuildHook = callPackage ({ }:
    makeSetupHook {
      name = "maturin-build-hook.sh";
      propagatedBuildInputs = [ cargo maturin rustc ];
      substitutions = {
        inherit ccForBuild ccForHost cxxForBuild cxxForHost
          rustBuildPlatform rustTargetPlatform rustTargetPlatformSpec;
      };
    } ./maturin-build-hook.sh) {};

    bindgenHook = callPackage ({}: makeSetupHook {
      name = "rust-bindgen-hook";
      substitutions = {
        libclang = clang.cc.lib;
        inherit clang;
      };
    }
    ./rust-bindgen-hook.sh) {};
}
