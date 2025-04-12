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

{
  name ? "${args.pname}-${args.version}",

  # Name for the vendored dependencies tarball
  cargoDepsName ? name,

  src ? null,
  srcs ? null,
  preUnpack ? null,
  unpackPhase ? null,
  postUnpack ? null,
  cargoPatches ? [ ],
  patches ? [ ],
  sourceRoot ? null,
  cargoRoot ? null,
  logLevel ? "",
  buildInputs ? [ ],
  nativeBuildInputs ? [ ],
  cargoUpdateHook ? "",
  cargoDepsHook ? "",
  buildType ? "release",
  meta ? { },
  useFetchCargoVendor ? false,
  cargoDeps ? null,
  cargoLock ? null,
  cargoVendorDir ? null,
  checkType ? buildType,
  buildNoDefaultFeatures ? false,
  checkNoDefaultFeatures ? buildNoDefaultFeatures,
  buildFeatures ? [ ],
  checkFeatures ? buildFeatures,
  useNextest ? false,
  auditable ? !cargo-auditable.meta.broken,

  depsExtraArgs ? { },

  # Toggles whether a custom sysroot is created when the target is a .json file.
  __internal_dontAddSysroot ? false,

  # Needed to `pushd`/`popd` into a subdir of a tarball if this subdir
  # contains a Cargo.toml, but isn't part of a workspace (which is e.g. the
  # case for `rustfmt`/etc from the `rust-sources).
  # Otherwise, everything from the tarball would've been built/tested.
  buildAndTestSubdir ? null,
  ...
}@args:

assert
  cargoVendorDir == null && cargoDeps == null && cargoLock == null
  ->
    !(args ? cargoSha256 && args.cargoSha256 != null) && !(args ? cargoHash && args.cargoHash != null)
  -> throw "cargoHash, cargoVendorDir, cargoDeps, or cargoLock must be set";

let

  cargoDeps' =
    if cargoVendorDir != null then
      null
    else if cargoDeps != null then
      cargoDeps
    else if cargoLock != null then
      importCargoLock cargoLock
    else if useFetchCargoVendor then
      fetchCargoVendor (
        {
          inherit
            src
            srcs
            sourceRoot
            cargoRoot
            preUnpack
            unpackPhase
            postUnpack
            ;
          name = cargoDepsName;
          patches = cargoPatches;
          hash = args.cargoHash;
        }
        // depsExtraArgs
      )
    else
      fetchCargoTarball (
        {
          inherit
            src
            srcs
            sourceRoot
            cargoRoot
            preUnpack
            unpackPhase
            postUnpack
            cargoUpdateHook
            ;
          name = cargoDepsName;
          patches = cargoPatches;
        }
        // lib.optionalAttrs (args ? cargoHash) {
          hash = args.cargoHash;
        }
        // lib.optionalAttrs (args ? cargoSha256) {
          sha256 = lib.warn "cargoSha256 is deprecated. Please use cargoHash with SRI hash instead" args.cargoSha256;
        }
        // depsExtraArgs
      );

  target = stdenv.hostPlatform.rust.rustcTargetSpec;
  targetIsJSON = lib.hasSuffix ".json" target;
  useSysroot = targetIsJSON && !__internal_dontAddSysroot;

  sysroot = callPackage ./sysroot { } {
    inherit target;
    shortTarget = stdenv.hostPlatform.rust.cargoShortTarget;
    RUSTFLAGS = args.RUSTFLAGS or "";
    originalCargoToml = src + /Cargo.toml; # profile info is later extracted
  };

in

# Tests don't currently work for `no_std`, and all custom sysroots are currently built without `std`.
# See https://os.phil-opp.com/testing/ for more information.
assert useSysroot -> !(args.doCheck or true);

stdenv.mkDerivation (
  (removeAttrs args [
    "depsExtraArgs"
    "cargoUpdateHook"
    "cargoDeps"
    "cargoLock"
  ])
  // lib.optionalAttrs useSysroot {
    RUSTFLAGS = "--sysroot ${sysroot} " + (args.RUSTFLAGS or "");
  }
  // lib.optionalAttrs (stdenv.hostPlatform.isDarwin && buildType == "debug") {
    RUSTFLAGS =
      "-C split-debuginfo=packed "
      + lib.optionalString useSysroot "--sysroot ${sysroot} "
      + (args.RUSTFLAGS or "");
  }
  // {
    cargoDeps = cargoDeps';
    inherit buildAndTestSubdir;

    cargoBuildType = buildType;

    cargoCheckType = checkType;

    cargoBuildNoDefaultFeatures = buildNoDefaultFeatures;

    cargoCheckNoDefaultFeatures = checkNoDefaultFeatures;

    cargoBuildFeatures = buildFeatures;

    cargoCheckFeatures = checkFeatures;

    patchRegistryDeps = ./patch-registry-deps;

    nativeBuildInputs =
      nativeBuildInputs
      ++ lib.optionals auditable [
        (buildPackages.cargo-auditable-cargo-wrapper.override {
          inherit cargo cargo-auditable;
        })
      ]
      ++ [
        cargoBuildHook
        (if useNextest then cargoNextestHook else cargoCheckHook)
        cargoInstallHook
        cargoSetupHook
        rustc
      ];

    buildInputs =
      buildInputs
      ++ lib.optionals stdenv.hostPlatform.isDarwin [ libiconv ]
      ++ lib.optionals stdenv.hostPlatform.isMinGW [ windows.pthreads ];

    patches = cargoPatches ++ patches;

    PKG_CONFIG_ALLOW_CROSS = if stdenv.buildPlatform != stdenv.hostPlatform then 1 else 0;

    postUnpack =
      ''
        eval "$cargoDepsHook"

        export RUST_LOG=${logLevel}
      ''
      + (args.postUnpack or "");

    configurePhase =
      args.configurePhase or ''
        runHook preConfigure
        runHook postConfigure
      '';

    doCheck = args.doCheck or true;

    strictDeps = true;

    meta = meta // {
      badPlatforms = meta.badPlatforms or [ ] ++ rustc.badTargetPlatforms;
      # default to Rust's platforms
      platforms = lib.intersectLists meta.platforms or lib.platforms.all rustc.targetPlatforms;
    };
  }
)
