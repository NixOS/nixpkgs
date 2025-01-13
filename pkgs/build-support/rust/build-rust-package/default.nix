{
  lib,
  importCargoLock,
  fetchCargoTarball,
  fetchCargoVendor,
  stdenv,
  callPackage,
  cargoBuildHook,
  cargoCheckHook,
  cargoInstallHook,
  cargoNextestHook,
  cargoSetupHook,
  cargo,
  cargo-auditable,
  buildPackages,
  rustc,
  libiconv,
  windows,
}:

# These things may be useful to put inside lib.
let
  # inherit the listed names of an attrset into an new attrset, but only if the name actually exists
  takeAttrs = names: lib.filterAttrs (n: _: lib.elem n names);

  # essentially lib.extends, but without doing `prev //` with the result
  transforms =
    transformation: rattrs: # <-- inputs
    final:
    transformation final (rattrs final);
in

let

  target = stdenv.hostPlatform.rust.rustcTargetSpec;
  targetIsJSON = lib.hasSuffix ".json" target;

  # outputs what attrs should be passed to mkDerivation given the attrs supplied to buildRustPackage
  transformAttrs =
    finalAttrs: inputAttrs:
    # the following attrset contains the default values that will be passed to mkDerivation, unless the user sets the given value
    {
      cargoDepsName = finalAttrs.name or "${finalAttrs.pname}-${finalAttrs.version}";

      cargoPatches = [ ];

      useFetchCargoVendor = false;

      cargoDeps =
        if (finalAttrs ? cargoVendorDir && finalAttrs.cargoVendorDir != null) then
          null
        else if
          (finalAttrs ? passthru && finalAttrs.passthru ? cargoLock && finalAttrs.passthru.cargoLock != null)
        then
          importCargoLock finalAttrs.passthru.cargoLock
        else if finalAttrs.useFetchCargoVendor then
          fetchCargoVendor (
            (takeAttrs [
              "src"
              "srcs"
              "sourceRoot"
              "cargoRoot"
              "preUnpack"
              "unpackPhase"
              "postUnpack"
            ] finalAttrs)
            // {
              name = finalAttrs.cargoDepsName;
              patches = finalAttrs.cargoPatches;
              hash = finalAttrs.cargoHash;
            }
            // finalAttrs.passthru.depsExtraArgs or { }
          )
        else if
          (
            (finalAttrs ? cargoHash && finalAttrs.cargoHash != null)
            || (finalAttrs ? cargoSha256 && finalAttrs.cargoSha256 != null)
          )
        then
          fetchCargoTarball (
            (takeAttrs [
              "src"
              "srcs"
              "sourceRoot"
              "cargoRoot"
              "preUnpack"
              "unpackPhase"
              "postUnpack"
              "cargoUpdateHook" # TODO: maybe remove in the future
            ] finalAttrs)
            // {
              name = finalAttrs.cargoDepsName;
              patches = finalAttrs.cargoPatches;
            }
            // lib.optionalAttrs (finalAttrs ? cargoHash) {
              hash = finalAttrs.cargoHash;
            }
            // lib.optionalAttrs (finalAttrs ? cargoSha256) {
              sha256 = lib.warn "cargoSha256 is deprecated. Please use cargoHash with SRI hash instead" finalAttrs.cargoSha256;
            }
            // finalAttrs.passthru.depsExtraArgs or { }
          )
        else
          throw "cargoHash, cargoVendorDir, or cargoLock must be set";

      # Needed to `pushd`/`popd` into a subdir of a tarball if this subdir
      # contains a Cargo.toml, but isn't part of a workspace (which is e.g. the
      # case for `rustfmt`/etc from the `rust-sources).
      # Otherwise, everything from the tarball would've been built/tested.
      buildAndTestSubdir = null;
      # TODO: ^^^^^^ shouldn't this become prefixed? (NOTE: this name is used by the maturin hook and cargo-tauri hook too)
      # TODO: this doesn't *need* to be here, since it's only every used by hooks
      #       it's may be helpful to keep it here for documentation purposes
      #       but maybe it would be better to move the documentation into the hooks?

      # TODO: should we disable having the prefixed attrs in inputAttrs?
      #       the current behaviour would shadow the unprefixed values, which seems fine
      cargoBuildType = inputAttrs.buildType or "release";
      cargoBuildFeatures = inputAttrs.buildFeatures or [ ];
      cargoBuildNoDefaultFeatures = inputAttrs.buildNoDefaultFeatures or false;

      cargoCheckType = finalAttrs.cargoBuildType;
      cargoCheckFeatures = finalAttrs.cargoBuildFeatures;
      cargoCheckNoDefaultFeatures = finalAttrs.cargoBuildNoDefaultFeatures;

      auditable = !cargo-auditable.meta.broken;

      useNextest = false;

      PKG_CONFIG_ALLOW_CROSS = if stdenv.buildPlatform != stdenv.hostPlatform then 1 else 0;

      doCheck = true;

      strictDeps = true;

      # Toggles whether a custom sysroot is created when the target is a .json file.
      __internal_dontAddSysroot = false;

      # Will be appended to the RUSTFLAGS environment variable. Should not really be overridden by users.
      # This is done in order to support both RUSTFLAGS and env.RUSTFLAGS
      # TODO: should this be uppercase? this is supposed to just be a shell variable
      # TODO: better names? __extraRustFlags? or should this just be interpolated straight into postUnpack?
      EXTRA_RUSTFLAGS =
        let
          sysroot =
            # Tests don't currently work for `no_std`, and all custom sysroots are currently built without `std`.
            # See https://os.phil-opp.com/testing/ for more information.
            assert !finalAttrs.doCheck;
            callPackage ./sysroot { } {
              inherit target;
              shortTarget = stdenv.hostPlatform.rust.cargoShortTarget;
              RUSTFLAGS = finalAttrs.RUSTFLAGS or ""; # TODO: what about env.*?
              originalCargoToml = finalAttrs.src + /Cargo.toml; # profile info is later extracted
            };
        in
        toString (
          lib.optionals (stdenv.hostPlatform.isDarwin && finalAttrs.cargoBuildType == "debug") [
            "-C split-debuginfo=packed"
          ]
          ++ lib.optionals (targetIsJSON && !finalAttrs.__internal_dontAddSysroot) [ "--sysroot ${sysroot}" ]
        );

    }
    # this is the attrset specified by the user, with some exceptional names removed
    # these are usually moved to be accessible under another name
    // lib.removeAttrs inputAttrs [
      # these get get prefixed, e.g.: buildType -> cargoBuildType
      "buildType"
      "buildFeatures"
      "buildNoDefaultFeatures"
      "checkType"
      "checkFeatures"
      "checkNoDefaultFeatures"
      # these get moved into passthru.* instead
      "cargoLock"
      "depsExtraArgs"
    ]
    # the following attrset is overlayed on top of the inputs, extending it with extra/modified values
    // {
      nativeBuildInputs =
        inputAttrs.nativeBuildInputs or [ ]
        ++ lib.optionals finalAttrs.auditable [
          (buildPackages.cargo-auditable-cargo-wrapper.override {
            inherit cargo cargo-auditable;
          })
        ]
        ++ [
          cargoBuildHook
          (if finalAttrs.useNextest then cargoNextestHook else cargoCheckHook)
          cargoInstallHook
          cargoSetupHook
          rustc
        ];

      buildInputs =
        inputAttrs.buildInputs or [ ]
        ++ lib.optionals stdenv.hostPlatform.isDarwin [ libiconv ]
        ++ lib.optionals stdenv.hostPlatform.isMinGW [ windows.pthreads ];

      patches = finalAttrs.cargoPatches ++ inputAttrs.patches or [ ];

      postUnpack = ''
        eval "$cargoDepsHook"

        export RUST_LOG="$logLevel"
        # TODO: ^^^^ I moved this here as a shell substitution, but this should probably be somewhere else

        export RUSTFLAGS+="$EXTRA_RUSTFLAGS"

        ${inputAttrs.postUnpack or ""}
      '';

      configurePhase = ''
        runHook preConfigure
        runHook postConfigure
      '';

      passthru = takeAttrs [ "cargoLock" "depsExtraArgs" ] inputAttrs // inputAttrs.passthru or { };

      meta = inputAttrs.meta or { } // {
        badPlatforms = inputAttrs.meta.badPlatforms or [ ] ++ rustc.badTargetPlatforms;
        # default to Rust's platforms
        platforms = lib.intersectLists (inputAttrs.meta.platforms or lib.platforms.all
        ) rustc.targetPlatforms;
      };
    };

in

attrsOrFn: stdenv.mkDerivation (transforms transformAttrs (lib.toFunction attrsOrFn))
