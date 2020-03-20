{ stdenv, cacert, git, rust, cargo, rustc, fetchCargoTarball, buildPackages, windows }:

{ name ? "${args.pname}-${args.version}"
, cargoSha256 ? "unset"
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
, target ? null
, cargoVendorDir ? null
, ... } @ args:

assert cargoVendorDir == null -> cargoSha256 != "unset";
assert buildType == "release" || buildType == "debug";

let

  cargoDeps = if cargoVendorDir == null
    then fetchCargoTarball {
        inherit name src srcs sourceRoot unpackPhase cargoUpdateHook;
        patches = cargoPatches;
        sha256 = cargoSha256;
      }
    else null;

  # If we have a cargoSha256 fixed-output derivation, validate it at build time
  # against the src fixed-output derivation to check consistency.
  validateCargoDeps = cargoSha256 != "unset";

  # Some cargo builds include build hooks that modify their own vendor
  # dependencies. This copies the vendor directory into the build tree and makes
  # it writable. If we're using a tarball, the unpackFile hook already handles
  # this for us automatically.
  setupVendorDir = if cargoVendorDir == null
    then (''
      unpackFile "$cargoDeps"
      cargoDepsCopy=$(stripHash $cargoDeps)
    '')
    else ''
      cargoDepsCopy="$sourceRoot/${cargoVendorDir}"
    '';

  rustTarget = if target == null then rust.toRustTarget stdenv.hostPlatform else target;

  ccForBuild="${buildPackages.stdenv.cc}/bin/${buildPackages.stdenv.cc.targetPrefix}cc";
  cxxForBuild="${buildPackages.stdenv.cc}/bin/${buildPackages.stdenv.cc.targetPrefix}c++";
  ccForHost="${stdenv.cc}/bin/${stdenv.cc.targetPrefix}cc";
  cxxForHost="${stdenv.cc}/bin/${stdenv.cc.targetPrefix}c++";
  releaseDir = "target/${rustTarget}/${buildType}";

in

stdenv.mkDerivation (args // {
  inherit cargoDeps;

  patchRegistryDeps = ./patch-registry-deps;

  nativeBuildInputs = nativeBuildInputs ++ [ cacert git cargo rustc ];
  buildInputs = buildInputs ++ stdenv.lib.optional stdenv.hostPlatform.isMinGW windows.pthreads;

  patches = cargoPatches ++ patches;

  PKG_CONFIG_ALLOW_CROSS =
    if stdenv.buildPlatform != stdenv.hostPlatform then 1 else 0;

  postUnpack = ''
    eval "$cargoDepsHook"

    ${setupVendorDir}

    mkdir .cargo
    config="$(pwd)/$cargoDepsCopy/.cargo/config";
    if [[ ! -e $config ]]; then
      config=${./fetchcargo-default-config.toml};
    fi;
    substitute $config .cargo/config \
      --subst-var-by vendor "$(pwd)/$cargoDepsCopy"

    cat >> .cargo/config <<'EOF'
    [target."${rust.toRustTarget stdenv.buildPlatform}"]
    "linker" = "${ccForBuild}"
    ${stdenv.lib.optionalString (stdenv.buildPlatform.config != stdenv.hostPlatform.config) ''
    [target."${rustTarget}"]
    "linker" = "${ccForHost}"
    ${# https://github.com/rust-lang/rust/issues/46651#issuecomment-433611633
      stdenv.lib.optionalString (stdenv.hostPlatform.isMusl && stdenv.hostPlatform.isAarch64) ''
    "rustflags" = [ "-C", "target-feature=+crt-static", "-C", "link-arg=-lgcc" ]
    ''}
    ''}
    EOF

    export RUST_LOG=${logLevel}
  '' + (args.postUnpack or "");

  # After unpacking and applying patches, check that the Cargo.lock matches our
  # src package. Note that we do this after the patchPhase, because the
  # patchPhase may create the Cargo.lock if upstream has not shipped one.
  postPatch = (args.postPatch or "") + stdenv.lib.optionalString validateCargoDeps ''
    cargoDepsLockfile=$NIX_BUILD_TOP/$cargoDepsCopy/Cargo.lock
    srcLockfile=$NIX_BUILD_TOP/$sourceRoot/Cargo.lock

    echo "Validating consistency between $srcLockfile and $cargoDepsLockfile"
    if ! diff $srcLockfile $cargoDepsLockfile; then

      # If the diff failed, first double-check that the file exists, so we can
      # give a friendlier error msg.
      if ! [ -e $srcLockfile ]; then
        echo "ERROR: Missing Cargo.lock from src. Expected to find it at: $srcLockfile"
        exit 1
      fi

      if ! [ -e $cargoDepsLockfile ]; then
        echo "ERROR: Missing lockfile from cargo vendor. Expected to find it at: $cargoDepsLockfile"
        exit 1
      fi

      echo
      echo "ERROR: cargoSha256 is out of date"
      echo
      echo "Cargo.lock is not the same in $cargoDepsCopy"
      echo
      echo "To fix the issue:"
      echo '1. Use "0000000000000000000000000000000000000000000000000000" as the cargoSha256 value'
      echo "2. Build the derivation and wait it to fail with a hash mismatch"
      echo "3. Copy the 'got: sha256:' value back into the cargoSha256 field"
      echo

      exit 1
    fi
  '' + ''
    unset cargoDepsCopy
  '';

  configurePhase = args.configurePhase or ''
    runHook preConfigure
    runHook postConfigure
  '';

  buildPhase = with builtins; args.buildPhase or ''
    runHook preBuild

    (
    set -x
    env \
      "CC_${rust.toRustTarget stdenv.buildPlatform}"="${ccForBuild}" \
      "CXX_${rust.toRustTarget stdenv.buildPlatform}"="${cxxForBuild}" \
      "CC_${rust.toRustTarget stdenv.hostPlatform}"="${ccForHost}" \
      "CXX_${rust.toRustTarget stdenv.hostPlatform}"="${cxxForHost}" \
      cargo build \
        ${stdenv.lib.optionalString (buildType == "release") "--release"} \
        --target ${rustTarget} \
        --frozen ${concatStringsSep " " cargoBuildFlags}
    )

    # rename the output dir to a architecture independent one
    mapfile -t targets < <(find "$NIX_BUILD_TOP" -type d | grep '${releaseDir}$')
    for target in "''${targets[@]}"; do
      rm -rf "$target/../../${buildType}"
      ln -srf "$target" "$target/../../"
    done

    runHook postBuild
  '';

  checkPhase = args.checkPhase or ''
    runHook preCheck
    echo "Running cargo cargo test -- ''${checkFlags} ''${checkFlagsArray+''${checkFlagsArray[@]}}"
    cargo test -- ''${checkFlags} ''${checkFlagsArray+"''${checkFlagsArray[@]}"}
    runHook postCheck
  '';

  doCheck = args.doCheck or true;

  inherit releaseDir;

  installPhase = args.installPhase or ''
    runHook preInstall
    mkdir -p $out/bin $out/lib

    find $releaseDir \
      -maxdepth 1 \
      -type f \
      -executable ! \( -regex ".*\.\(so.[0-9.]+\|so\|a\|dylib\)" \) \
      -print0 | xargs -r -0 cp -t $out/bin
    find $releaseDir \
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
