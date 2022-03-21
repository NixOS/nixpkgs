{ buildPackages
, callPackage
, cargo
, clang
, diffutils
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
      deps = [ cargo ];
      substitutions = {
        inherit ccForBuild ccForHost cxxForBuild cxxForHost
          rustBuildPlatform rustTargetPlatform rustTargetPlatformSpec;
      };
    } ./cargo-build-hook.sh) {};

  cargoCheckHook = callPackage ({ }:
    makeSetupHook {
      name = "cargo-check-hook.sh";
      deps = [ cargo ];
      substitutions = {
        inherit rustTargetPlatformSpec;
      };
    } ./cargo-check-hook.sh) {};

  cargoInstallHook = callPackage ({ }:
    makeSetupHook {
      name = "cargo-install-hook.sh";
      deps = [ ];
      substitutions = {
        inherit shortTarget;
      };
    } ./cargo-install-hook.sh) {};

  cargoSetupHook = callPackage ({ }:
    makeSetupHook {
      name = "cargo-setup-hook.sh";
      deps = [ ];
      substitutions = {
        defaultConfig = ../fetchcargo-default-config.toml;

        # Specify the stdenv's `diff` by abspath to ensure that the user's build
        # inputs do not cause us to find the wrong `diff`.
        # The `.nativeDrv` stanza works like nativeBuildInputs and ensures cross-compiling has the right version available.
        diff = "${diffutils.nativeDrv or diffutils}/bin/diff";

        # Target platform
        rustTarget = ''
          [target."${rust.toRustTarget stdenv.buildPlatform}"]
          "linker" = "${ccForBuild}"
          ${lib.optionalString (stdenv.buildPlatform.config != stdenv.hostPlatform.config) ''
            [target."${shortTarget}"]
            "linker" = "${ccForHost}"
            ${# https://github.com/rust-lang/rust/issues/46651#issuecomment-433611633
            lib.optionalString (stdenv.hostPlatform.isMusl && stdenv.hostPlatform.isAarch64) ''
              "rustflags" = [ "-C", "target-feature=+crt-static", "-C", "link-arg=-lgcc" ]
            ''}
          ''}
        '';
      };
    } ./cargo-setup-hook.sh) {};

  maturinBuildHook = callPackage ({ }:
    makeSetupHook {
      name = "maturin-build-hook.sh";
      deps = [ cargo maturin rustc ];
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
