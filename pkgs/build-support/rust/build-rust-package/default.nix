{ lib
, importCargoLock
, fetchCargoTarball
, rust
, stdenv
, callPackage
, cacert
, git
, cargoBuildHook
, cargoCheckHook
, cargoInstallHook
, cargoSetupHook
, rustc
, libiconv
, windows
}:

{ cargoLock ? null
, cargoVendorDir ? null

  # Toggles whether a custom sysroot is created when the target is a .json file.
, __internal_dontAddSysroot ? false

  # Needed to `pushd`/`popd` into a subdir of a tarball if this subdir
  # contains a Cargo.toml, but isn't part of a workspace (which is e.g. the
  # case for `rustfmt`/etc from the `rust-sources).
  # Otherwise, everything from the tarball would've been built/tested.
, buildAndTestSubdir ? null
, ...
} @ args:

assert cargoVendorDir == null && cargoLock == null -> !(args ? cargoSha256) && !(args ? cargoHash)
  -> throw "cargoSha256, cargoHash, cargoVendorDir, or cargoLock must be set";

# depsExtraArgs, cargoLock have to be removed otherwise 'cannot coerce a set to a string'
# with structuredAttrs this won't be needed
# also cargoUpdateHook to avoid changing hashes
(stdenv.mkDerivation (removeAttrs args [ "depsExtraArgs" "cargoLock" "cargoUpdateHook" ])).overrideAttrs (finalAttrs: previousAttrs:
  let
    # If we have a cargoSha256 fixed-output derivation, validate it at build time
    # against the src fixed-output derivation to check consistency.
    # NOTE: this seems unused
    #validateCargoDeps = finalAttrs ? cargoHash || finalAttrs ? cargoSha256;

    target = rust.toRustTargetSpec stdenv.hostPlatform;
    targetIsJSON = lib.hasSuffix ".json" target;
    useSysroot = targetIsJSON && !__internal_dontAddSysroot;

    # see https://github.com/rust-lang/cargo/blob/964a16a28e234a3d397b2a7031d4ab4a428b1391/src/cargo/core/compiler/compile_kind.rs#L151-L168
    # the "${}" is needed to transform the path into a /nix/store path before baseNameOf
    shortTarget =
      if targetIsJSON then
        (lib.removeSuffix ".json" (builtins.baseNameOf "${target}"))
      else target;
    sysroot = callPackage ./sysroot { } {
      inherit target shortTarget;
      RUSTFLAGS = finalAttrs.RUSTFLAGS or "";
      originalCargoToml = finalAttrs.src + /Cargo.toml; # profile info is later extracted
    };

    cargoDeps =
      if cargoVendorDir != null then null
      else if cargoLock != null then importCargoLock cargoLock
      else
        fetchCargoTarball ({
          src = finalAttrs.src or "";
          srcs = finalAttrs.srcs or null;
          sourceRoot = finalAttrs.sourceRoot or null;
          unpackPhase = finalAttrs.unpackPhase or null;
          cargoUpdateHook = finalAttrs.cargoUpdateHook or args.cargoUpdateHook or "";
          # Name for the vendored dependencies tarball
          name = finalAttrs.cargoDepsName or finalAttrs.name or "${finalAttrs.pname}-${finalAttrs.version}";
          # see comment below
          #patches = finalAttrs.cargoPatches;
          patches = finalAttrs.cargoPatches or [ ];
        } // lib.optionalAttrs (finalAttrs ? cargoHash) {
          hash = finalAttrs.cargoHash;
        } // lib.optionalAttrs (finalAttrs ? cargoSha256) {
          sha256 = finalAttrs.cargoSha256;
        } // (args.depsExtraArgs or { }));

    maybeSetStr = x: lib.optionalString (previousAttrs ? ${x}) previousAttrs.${x};
    maybeSetListFromPrevious = x: lib.optionals (previousAttrs ? ${x}) previousAttrs.${x};

    # cargoBuildFeatures example:
    # previous: use directly specified cargoBuildFeatures from the original derivation (the one in nixpkgs)
    # final: use buildType from either the original derivation or one overriden with overrideAttrs
    # default: use the default passed if none of the above are set
    pickPreviousOrFinalOrDefault = previous: final: default: (previousAttrs.${previous} or finalAttrs.${final} or default);

  in

  # Tests don't currently work for `no_std`, and all custom sysroots are currently built without `std`.
    # See https://os.phil-opp.com/testing/ for more information.
  assert useSysroot -> !(finalAttrs.doCheck or true);
  {
    inherit buildAndTestSubdir cargoDeps;

    # buildType is checked for 4 of the cargo built in types
    # directly specifying cargoBuildType can be used as a escape-hatch
    cargoBuildType = assert finalAttrs ? buildType -> lib.assertOneOf "buildType" finalAttrs.buildType [ "release" "debug" "test" "bench" ];
      pickPreviousOrFinalOrDefault "cargoBuildType" "buildType" "release";

    cargoCheckType = pickPreviousOrFinalOrDefault "cargoCheckType" "checkType" finalAttrs.cargoBuildType;

    cargoBuildNoDefaultFeatures = pickPreviousOrFinalOrDefault "cargoBuildNoDefaultFeatures" "buildNoDefaultFeatures" false;

    cargoCheckNoDefaultFeatures = pickPreviousOrFinalOrDefault "cargoCheckNoDefaultFeatures" "checkNoDefaultFeatures"
      finalAttrs.cargoBuildNoDefaultFeatures;

    cargoBuildFeatures = pickPreviousOrFinalOrDefault "cargoBuildFeatures" "buildFeatures" "";

    cargoCheckFeatures = pickPreviousOrFinalOrDefault "cargoCheckFeatures" "checkFeatures" finalAttrs.cargoBuildFeatures;

    patchRegistryDeps = ./patch-registry-deps;

    nativeBuildInputs = maybeSetListFromPrevious "nativeBuildInputs" ++ [
      cacert
      git
      cargoBuildHook
      cargoCheckHook
      cargoInstallHook
      cargoSetupHook
      rustc
    ];

    buildInputs = maybeSetListFromPrevious "buildInputs"
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ libiconv ]
    ++ lib.optionals stdenv.hostPlatform.isMinGW [ windows.pthreads ];

    # commented for now to keep drv hash from changing
    #cargoPatches = maybeSetListFromPrevious "cargoPatches";
    #patches = finalAttrs.cargoPatches ++ maybeSetListFromPrevious "patches";

    patches = (finalAttrs.cargoPatches or [ ]) ++ maybeSetListFromPrevious "patches";

    PKG_CONFIG_ALLOW_CROSS = previousAttrs.PKG_CONFIG_ALLOW_CROSS or
      (if stdenv.buildPlatform != stdenv.hostPlatform then 1 else 0);

    postUnpack = ''
      eval "$cargoDepsHook"

      export RUST_LOG=${finalAttrs.logLevel or ""}
    '' + maybeSetStr "postUnpack";

    configurePhase = previousAttrs.configurePhase or ''
      runHook preConfigure
      runHook postConfigure
    '';

    doCheck = previousAttrs.doCheck or true;

    strictDeps = previousAttrs.strictDeps or true;

    passthru = { inherit cargoDeps; } // (previousAttrs.passthru or { });

    meta = {
      # default to Rust's platforms
      platforms = rustc.meta.platforms;
    } // previousAttrs.meta or { };

  } // lib.optionalAttrs useSysroot
    { RUSTFLAGS = "--sysroot ${sysroot} " + (previousAttrs.RUSTFLAGS or ""); })
