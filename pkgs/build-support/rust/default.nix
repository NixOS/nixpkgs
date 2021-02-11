{ stdenv
, lib
, buildPackages
, cacert
, cargo
, cargoBuildHook
, cargoSetupHook
, fetchCargoTarball
, runCommandNoCC
, rustPlatform
, callPackage
, remarshal
, git
, rust
, rustc
, windows
}:

{ name ? "${args.pname}-${args.version}"

  # SRI hash
, cargoHash ? ""

  # Legacy hash
, cargoSha256 ? ""

, src ? null
, srcs ? null
, unpackPhase ? null
, cargoPatches ? []
, patches ? []
, sourceRoot ? null
, logLevel ? ""
, buildInputs ? []
, nativeBuildInputs ? []
, cargoUpdateHook ? ""
, cargoDepsHook ? ""
, cargoBuildFlags ? []
, buildType ? "release"
, meta ? {}
, cargoVendorDir ? null
, checkType ? buildType
, depsExtraArgs ? {}
, cargoParallelTestThreads ? true

# Toggles whether a custom sysroot is created when the target is a .json file.
, __internal_dontAddSysroot ? false

# Needed to `pushd`/`popd` into a subdir of a tarball if this subdir
# contains a Cargo.toml, but isn't part of a workspace (which is e.g. the
# case for `rustfmt`/etc from the `rust-sources).
# Otherwise, everything from the tarball would've been built/tested.
, buildAndTestSubdir ? null
, ... } @ args:

assert cargoVendorDir == null -> !(cargoSha256 == "" && cargoHash == "");
assert buildType == "release" || buildType == "debug";

let

  cargoDeps = if cargoVendorDir == null
    then fetchCargoTarball ({
        inherit name src srcs sourceRoot unpackPhase cargoUpdateHook;
        hash = cargoHash;
        patches = cargoPatches;
        sha256 = cargoSha256;
      } // depsExtraArgs)
    else null;

  # If we have a cargoSha256 fixed-output derivation, validate it at build time
  # against the src fixed-output derivation to check consistency.
  validateCargoDeps = !(cargoHash == "" && cargoSha256 == "");

  target = rust.toRustTargetSpec stdenv.hostPlatform;
  targetIsJSON = lib.hasSuffix ".json" target;
  useSysroot = targetIsJSON && !__internal_dontAddSysroot;

  # see https://github.com/rust-lang/cargo/blob/964a16a28e234a3d397b2a7031d4ab4a428b1391/src/cargo/core/compiler/compile_kind.rs#L151-L168
  # the "${}" is needed to transform the path into a /nix/store path before baseNameOf
  shortTarget = if targetIsJSON then
      (lib.removeSuffix ".json" (builtins.baseNameOf "${target}"))
    else target;

  sysroot = (callPackage ./sysroot {}) {
    inherit target shortTarget;
    RUSTFLAGS = args.RUSTFLAGS or "";
    originalCargoToml = src + /Cargo.toml; # profile info is later extracted
  };

  releaseDir = "target/${shortTarget}/${buildType}";
  tmpDir = "${releaseDir}-tmp";

in

# Tests don't currently work for `no_std`, and all custom sysroots are currently built without `std`.
# See https://os.phil-opp.com/testing/ for more information.
assert useSysroot -> !(args.doCheck or true);

stdenv.mkDerivation ((removeAttrs args ["depsExtraArgs"]) // lib.optionalAttrs useSysroot {
  RUSTFLAGS = "--sysroot ${sysroot} " + (args.RUSTFLAGS or "");
} // {
  inherit buildAndTestSubdir cargoDeps releaseDir tmpDir;

  cargoBuildFlags = lib.concatStringsSep " " cargoBuildFlags;

  cargoBuildType = "--${buildType}";

  patchRegistryDeps = ./patch-registry-deps;

  nativeBuildInputs = nativeBuildInputs ++
    [ cacert git cargo cargoBuildHook cargoSetupHook rustc ];

  buildInputs = buildInputs ++ lib.optional stdenv.hostPlatform.isMinGW windows.pthreads;

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

  checkPhase = args.checkPhase or (let
    argstr = "${lib.optionalString (checkType == "release") "--release"} --target ${target} --frozen";
    threads = if cargoParallelTestThreads then "$NIX_BUILD_CORES" else "1";
  in ''
    ${lib.optionalString (buildAndTestSubdir != null) "pushd ${buildAndTestSubdir}"}
    runHook preCheck
    echo "Running cargo test ${argstr} -- ''${checkFlags} ''${checkFlagsArray+''${checkFlagsArray[@]}}"
    cargo test -j $NIX_BUILD_CORES ${argstr} -- --test-threads=${threads} ''${checkFlags} ''${checkFlagsArray+"''${checkFlagsArray[@]}"}
    runHook postCheck
    ${lib.optionalString (buildAndTestSubdir != null) "popd"}
  '');

  doCheck = args.doCheck or true;

  strictDeps = true;

  installPhase = args.installPhase or ''
    runHook preInstall

    # This needs to be done after postBuild: packages like `cargo` do a pushd/popd in
    # the pre/postBuild-hooks that need to be taken into account before gathering
    # all binaries to install.
    mkdir -p $tmpDir
    cp -r $releaseDir/* $tmpDir/
    bins=$(find $tmpDir \
      -maxdepth 1 \
      -type f \
      -executable ! \( -regex ".*\.\(so.[0-9.]+\|so\|a\|dylib\)" \))

    # rename the output dir to a architecture independent one
    mapfile -t targets < <(find "$NIX_BUILD_TOP" -type d | grep '${tmpDir}$')
    for target in "''${targets[@]}"; do
      rm -rf "$target/../../${buildType}"
      ln -srf "$target" "$target/../../"
    done
    mkdir -p $out/bin $out/lib

    xargs -r cp -t $out/bin <<< $bins
    find $tmpDir \
      -maxdepth 1 \
      -regex ".*\.\(so.[0-9.]+\|so\|a\|dylib\)" \
      -print0 | xargs -r -0 cp -t $out/lib
    rmdir --ignore-fail-on-non-empty $out/lib $out/bin
    runHook postInstall
  '';

  passthru = { inherit cargoDeps; } // (args.passthru or {});

  meta = {
    # default to Rust's platforms
    platforms = rustc.meta.platforms;
  } // meta;
})
