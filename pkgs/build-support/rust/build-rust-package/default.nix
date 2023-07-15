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
, buildPackages
, rustc
, libiconv
, windows
}:

{ name ? "${args.pname}-${args.version}"

  # Name for the vendored dependencies tarball
, cargoDepsName ? name

, src ? null
, srcs ? null
, preUnpack ? null
, unpackPhase ? null
, postUnpack ? null
, cargoPatches ? []
, patches ? []
, sourceRoot ? null
, logLevel ? ""
, buildInputs ? []
, nativeBuildInputs ? []
, cargoUpdateHook ? ""
, cargoDepsHook ? ""
, buildType ? "release"
, meta ? {}
, cargoLock ? null
, cargoVendorDir ? null
, checkType ? buildType
, buildNoDefaultFeatures ? false
, checkNoDefaultFeatures ? buildNoDefaultFeatures
, buildFeatures ? [ ]
, checkFeatures ? buildFeatures
, useNextest ? false
, auditable ? !cargo-auditable.meta.broken

, depsExtraArgs ? {}

# Toggles whether a custom sysroot is created when the target is a .json file.
, __internal_dontAddSysroot ? false

# Needed to `pushd`/`popd` into a subdir of a tarball if this subdir
# contains a Cargo.toml, but isn't part of a workspace (which is e.g. the
# case for `rustfmt`/etc from the `rust-sources).
# Otherwise, everything from the tarball would've been built/tested.
, buildAndTestSubdir ? null
, ... } @ args:

assert cargoVendorDir == null && cargoLock == null
    -> !(args ? cargoSha256 && args.cargoSha256 != null) && !(args ? cargoHash && args.cargoHash != null)
    -> throw "cargoSha256, cargoHash, cargoVendorDir, or cargoLock must be set";
assert buildType == "release" || buildType == "debug";

let

  cargoDeps =
    if cargoVendorDir != null then null
    else if cargoLock != null then importCargoLock cargoLock
    else fetchCargoTarball ({
      inherit src srcs sourceRoot preUnpack unpackPhase postUnpack cargoUpdateHook;
      name = cargoDepsName;
      patches = cargoPatches;
    } // lib.optionalAttrs (args ? cargoHash) {
      hash = args.cargoHash;
    } // lib.optionalAttrs (args ? cargoSha256) {
      sha256 = args.cargoSha256;
    } // depsExtraArgs);

  target = rust.toRustTargetSpec stdenv.hostPlatform;
  targetIsJSON = lib.hasSuffix ".json" target;
  useSysroot = targetIsJSON && !__internal_dontAddSysroot;

  # see https://github.com/rust-lang/cargo/blob/964a16a28e234a3d397b2a7031d4ab4a428b1391/src/cargo/core/compiler/compile_kind.rs#L151-L168
  # the "${}" is needed to transform the path into a /nix/store path before baseNameOf
  shortTarget = if targetIsJSON then
      (lib.removeSuffix ".json" (builtins.baseNameOf "${target}"))
    else target;

  sysroot = callPackage ./sysroot { } {
    inherit target shortTarget;
    RUSTFLAGS = args.RUSTFLAGS or "";
    originalCargoToml = src + /Cargo.toml; # profile info is later extracted
  };

in

# Tests don't currently work for `no_std`, and all custom sysroots are currently built without `std`.
# See https://os.phil-opp.com/testing/ for more information.
assert useSysroot -> !(args.doCheck or true);

stdenv.mkDerivation ((removeAttrs args [ "depsExtraArgs" "cargoUpdateHook" "cargoLock" ]) // lib.optionalAttrs useSysroot {
  RUSTFLAGS = "--sysroot ${sysroot} " + (args.RUSTFLAGS or "");
} // {
  inherit buildAndTestSubdir cargoDeps;

  cargoBuildType = buildType;

  cargoCheckType = checkType;

  cargoBuildNoDefaultFeatures = buildNoDefaultFeatures;

  cargoCheckNoDefaultFeatures = checkNoDefaultFeatures;

  cargoBuildFeatures = buildFeatures;

  cargoCheckFeatures = checkFeatures;

  patchRegistryDeps = ./patch-registry-deps;

  nativeBuildInputs = nativeBuildInputs ++ lib.optionals auditable [
    (buildPackages.cargo-auditable-cargo-wrapper.override {
      inherit cargo cargo-auditable;
    })
  ] ++ [
    cargoBuildHook
    (if useNextest then cargoNextestHook else cargoCheckHook)
    cargoInstallHook
    cargoSetupHook
    rustc
  ];

  buildInputs = buildInputs
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ libiconv ]
    ++ lib.optionals stdenv.hostPlatform.isMinGW [ windows.pthreads ];

  patches = cargoPatches ++ patches;

  PKG_CONFIG_ALLOW_CROSS =
    if stdenv.buildPlatform != stdenv.hostPlatform then 1 else 0;

  postUnpack = ''
    eval "$cargoDepsHook"

    export RUST_LOG=${logLevel}
  '' + (args.postUnpack or "");

  configurePhase = args.configurePhase or ''
    runHook preConfigure
    runHook postConfigure
  '';

  doCheck = args.doCheck or true;

  strictDeps = true;

  meta = {
    # default to Rust's platforms
    platforms = rustc.meta.platforms ++ [
      # Platforms without host tools from
      # https://doc.rust-lang.org/nightly/rustc/platform-support.html
      "armv7a-darwin"
      "armv5tel-linux" "armv7a-linux" "m68k-linux" "riscv32-linux"
      "armv6l-netbsd"
      "x86_64-redox"
      "wasm32-wasi"
    ];
  } // meta;
})
