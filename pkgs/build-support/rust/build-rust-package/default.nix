{
  lib,
  importCargoLock,
  fetchCargoVendor,
  stdenv,
  cargoBuildHook,
  cargoCheckHook,
  cargoInstallHook,
  cargoNextestHook,
  cargoSetupHook,
  cargo,
  cargo-auditable,
  buildPackages,
  rustc,
  windows,
}:

let
  interpolateString =
    s:
    if lib.isList s then
      lib.concatMapStringsSep " " (s: "${s}") (lib.filter (s: s != null) s)
    else if s == null then
      ""
    else
      "${s}";
in
lib.extendMkDerivation {
  constructDrv = stdenv.mkDerivation;

  excludeDrvArgNames = [
    "depsExtraArgs"
    "cargoUpdateHook"
    "cargoLock"
    "useFetchCargoVendor"
    "RUSTFLAGS"
  ];

  extendDrvArgs =
    finalAttrs:
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
      useFetchCargoVendor ? true,
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

      # Needed to `pushd`/`popd` into a subdir of a tarball if this subdir
      # contains a Cargo.toml, but isn't part of a workspace (which is e.g. the
      # case for `rustfmt`/etc from the `rust-sources).
      # Otherwise, everything from the tarball would've been built/tested.
      buildAndTestSubdir ? null,
      ...
    }@args:

    assert lib.assertMsg useFetchCargoVendor
      "buildRustPackage: `useFetchCargoVendor` is non‐optional and enabled by default as of 25.05, remove it";

    assert lib.warnIf (args ? useFetchCargoVendor)
      "buildRustPackage: `useFetchCargoVendor` is non‐optional and enabled by default as of 25.05, remove it"
      true;
    {
      env = {
        PKG_CONFIG_ALLOW_CROSS = if stdenv.buildPlatform != stdenv.hostPlatform then 1 else 0;
        RUST_LOG = logLevel;
        RUSTFLAGS =
          lib.optionalString (
            stdenv.hostPlatform.isDarwin && buildType == "debug"
          ) "-C split-debuginfo=packed "
          # Workaround the existing RUSTFLAGS specified as a list.
          + interpolateString (args.RUSTFLAGS or "");
      }
      // args.env or { };

      cargoDeps =
        if cargoVendorDir != null then
          null
        else if cargoDeps != null then
          cargoDeps
        else if cargoLock != null then
          importCargoLock cargoLock
        else if args.cargoHash or null == null then
          throw "cargoHash, cargoVendorDir, cargoDeps, or cargoLock must be set"
        else
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
          );
      inherit buildAndTestSubdir;

      cargoBuildType = buildType;

      cargoCheckType = checkType;

      cargoBuildNoDefaultFeatures = buildNoDefaultFeatures;

      cargoCheckNoDefaultFeatures = checkNoDefaultFeatures;

      cargoBuildFeatures = buildFeatures;

      cargoCheckFeatures = checkFeatures;

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
          cargo
        ];

      buildInputs = buildInputs ++ lib.optionals stdenv.hostPlatform.isMinGW [ windows.pthreads ];

      patches = cargoPatches ++ patches;

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
    };
}
