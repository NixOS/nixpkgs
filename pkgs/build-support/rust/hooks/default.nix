{ buildPackages
, callPackage
, diffutils
, lib
, makeSetupHook
, rust
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
  ccForBuild="${buildPackages.stdenv.cc}/bin/${buildPackages.stdenv.cc.targetPrefix}cc";
  ccForHost="${stdenv.cc}/bin/${stdenv.cc.targetPrefix}cc";
in {
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
}
