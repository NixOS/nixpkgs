{ buildPackages
, callPackage
, cargo
, cargo-nextest
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

  cargoNextestHook = callPackage ({ }:
    makeSetupHook {
      name = "cargo-nextest-hook.sh";
      deps = [ cargo cargo-nextest ];
      substitutions = {
        inherit rustTargetPlatformSpec;
      };
    } ./cargo-nextest-hook.sh) {};

  cargoSetupHook = callPackage ({ }:
    makeSetupHook {
      name = "cargo-setup-hook.sh";
      deps = [ ];
      substitutions = {
        defaultConfig = ../fetchcargo-default-config.toml;

        # Specify the stdenv's `diff` by abspath to ensure that the user's build
        # inputs do not cause us to find the wrong `diff`.
        diff = "${lib.getBin buildPackages.diffutils}/bin/diff";

        # We want to specify the correct crt-static flag for both
        # the build and host platforms. This is important when the wanted
        # value for crt-static does not match the defaults in the rustc target,
        # like for pkgsMusl or pkgsCross.musl64; Upstream rustc still assumes
        # that musl = static[1].
        #
        # By default, Cargo doesn't apply RUSTFLAGS when building build.rs
        # if --target is passed, so the only good way to set crt-static for
        # build.rs files is to use the unstable -Zhost-config Cargo feature.
        # This allows us to specify flags that should be passed to rustc
        # when building for the build platform. We also need to use
        # -Ztarget-applies-to-host, because using -Zhost-config requires it.
        #
        # When doing this, we also have to specify the linker, or cargo
        # won't pass a -C linker= argument to rustc.  This will make rustc
        # try to use its default value of "cc", which won't be available
        # when cross-compiling.
        #
        # [1]: https://github.com/rust-lang/compiler-team/issues/422
        cargoConfig = ''
          [host]
          "linker" = "${ccForBuild}"
          "rustflags" = [ "-C", "target-feature=${if stdenv.buildPlatform.isStatic then "+" else "-"}crt-static" ]

          [target."${shortTarget}"]
          "linker" = "${ccForHost}"
          "rustflags" = [ "-C", "target-feature=${if stdenv.hostPlatform.isStatic then "+" else "-"}crt-static" ]

          [unstable]
          host-config = true
          target-applies-to-host = true
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
        libclang = rustc.llvmPackages.clang.cc.lib;
        clang = rustc.llvmPackages.clang;
      };
    }
    ./rust-bindgen-hook.sh) {};
}
