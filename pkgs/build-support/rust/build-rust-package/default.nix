{ lib
, importCargoLock
, fetchCargoTarball
, rust
, stdenv
, callPackage
, cargoBuildHook
, cargoCheckHook
, cargoInstallHook
, cargoNextestHook
, cargoSetupHook
, cargo
, cargo-auditable
, cargo-auditable-cargo-wrapper
, rustc
, libiconv
, windows
}:

let rustOverride =

finalAttrs: previousAttrs:

let
  cargoPatches = finalAttrs.cargoPatches or [];
  buildType = finalAttrs.buildType or "release";
  checkType = finalAttrs.checkType or buildType;
  cargoLock = finalAttrs.cargoLock or null;
  cargoVendorDir = finalAttrs.cargoVendorDir or null;
  buildNoDefaultFeatures = finalAttrs.buildNoDefaultFeatures or false;
  checkNoDefaultFeatures = finalAttrs.checkNoDefaultFeatures or buildNoDefaultFeatures;
  buildFeatures = finalAttrs.buildFeatures or [ ];
  checkFeatures = finalAttrs.checkFeatures or buildFeatures;
  useNextest = finalAttrs.useNextest or false;
  auditable = finalAttrs.auditable or true;
  depsExtraArgs = finalAttrs.depsExtraArgs or { };

  # Toggles whether a custom sysroot is created when the target is a .json file.
  __internal_dontAddSysroot = finalAttrs.__internal_dontAddSysroot or false;

  # Needed to `pushd`/`popd` into a subdir of a tarball if this subdir
  # contains a Cargo.toml, but isn't part of a workspace (which is e.g. the
  # case for `rustfmt`/etc from the `rust-sources).
  # Otherwise, everything from the tarball would've been built/tested.
  buildAndTestSubdir = finalAttrs.buildAndTestSubdir or null;

  cargoDeps =
    assert cargoVendorDir == null && cargoLock == null
        -> !(finalAttrs.cargoSha256 or null != null) && !(finalAttrs.cargoHash or null != null)
        -> throw "One of cargoSha256, cargoHash, cargoVendorDir or cargoLock must be set";
    if cargoVendorDir != null then null
    else if cargoLock != null then importCargoLock cargoLock
    else fetchCargoTarball ({
      src = finalAttrs.src or "";
      srcs = finalAttrs.srcs or null;
      sourceRoot = finalAttrs.sourceRoot or null;
      preUnpack = finalAttrs.preUnpack or null;
      unpackPhase = finalAttrs.unpackPhase or null;
      # TODO using previousAttrs here as we otherwise trigger rebuilds for all
      # FOD fetcher users as finalAttrs.postUnpack is prefixed below.
      postUnpack = previousAttrs.postUnpack or null;
      cargoUpdateHook = finalAttrs.cargoUpdateHook or "";
      # Name for the vendored dependencies tarball
      name = finalAttrs.cargoDepsName or finalAttrs.name or "${finalAttrs.pname}-${finalAttrs.version}";
      patches = cargoPatches;
    } // lib.optionalAttrs (finalAttrs ? cargoHash) {
      hash = finalAttrs.cargoHash;
    } // lib.optionalAttrs (finalAttrs ? cargoSha256) {
      sha256 = finalAttrs.cargoSha256;
    } // depsExtraArgs);

  target = rust.toRustTargetSpec stdenv.hostPlatform;
  targetIsJSON = lib.hasSuffix ".json" target;
  useSysroot = targetIsJSON && !__internal_dontAddSysroot;

  # see https://github.com/rust-lang/cargo/blob/964a16a28e234a3d397b2a7031d4ab4a428b1391/src/cargo/core/compiler/compile_kind.rs#L151-L168
  # the "${}" is needed to transform the path into a /nix/store path before baseNameOf
  shortTarget = if targetIsJSON then
      (lib.removeSuffix ".json" (builtins.baseNameOf "${target}"))
    else target;

  sysroot = lib.throwIf (finalAttrs.doCheck or false) ''
    Tests don't currently work for `no_std`, and all custom sysroots are
    currently built without `std`. See https://os.phil-opp.com/testing/ for more
    information.
  '' (callPackage ./sysroot { } {
    inherit target shortTarget;
    RUSTFLAGS = previousAttrs.RUSTFLAGS or "";
    originalCargoToml = finalAttrs.src + /Cargo.toml; # profile info is later extracted
  });

in

{
  removeFromBuilderEnv = [ "depsExtraArgs" "cargoUpdateHook" "cargoLock" ];

  RUSTFLAGS =
    if useSysroot then
      lib.optionalString useSysroot "--sysroot ${sysroot} "
        + (previousAttrs.RUSTFLAGS or "")
    else
      previousAttrs.RUSTFLAGS or null;

  inherit cargoDeps;

  buildAndTestSubdir = previousAttrs.buildAndTestSubdir or null;

  cargoBuildType =
    assert buildType == "release" || buildType == "debug";
    buildType;

  cargoCheckType = checkType;

  cargoBuildNoDefaultFeatures = buildNoDefaultFeatures;

  cargoCheckNoDefaultFeatures = checkNoDefaultFeatures;

  cargoBuildFeatures = buildFeatures;

  cargoCheckFeatures = checkFeatures;

  patchRegistryDeps = ./patch-registry-deps;

  nativeBuildInputs = (previousAttrs.nativeBuildInputs or [ ]) ++ lib.optionals auditable [
    (cargo-auditable-cargo-wrapper.override {
      inherit cargo cargo-auditable;
    })
  ] ++ [
    cargoBuildHook
    (if useNextest then cargoNextestHook else cargoCheckHook)
    cargoInstallHook
    cargoSetupHook
    rustc
  ];

  buildInputs = (previousAttrs.buildInputs or [ ])
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ libiconv ]
    ++ lib.optionals stdenv.hostPlatform.isMinGW [ windows.pthreads ];

  patches = cargoPatches ++ (previousAttrs.patches or [ ]);

  PKG_CONFIG_ALLOW_CROSS =
    if stdenv.buildPlatform != stdenv.hostPlatform then 1 else 0;

  postUnpack = ''
    eval "$cargoDepsHook"

    export RUST_LOG=${finalAttrs.logLevel or ""}
  '' + (previousAttrs.postUnpack or "");

  configurePhase = previousAttrs.configurePhase or ''
    runHook preConfigure
    runHook postConfigure
  '';

  doCheck = previousAttrs.doCheck or true;

  strictDeps = true;

  meta = {
    # default to Rust's platforms
    platforms = rustc.meta.platforms;
  } // (previousAttrs.meta or {});
};

in args: (stdenv.mkDerivation args).overrideAttrs rustOverride
