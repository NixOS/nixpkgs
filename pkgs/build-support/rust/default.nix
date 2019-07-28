{ stdenv, cacert, git, cargo, rustc, fetchcargo, buildPackages }:

{ name ? "${args.pname}-${args.version}"
, cargoSha256 ? "unset"
, src ? null
, srcs ? null
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

, cargoVendorDir ? null
, ... } @ args:

assert cargoVendorDir == null -> cargoSha256 != "unset";
assert buildType == "release" || buildType == "debug";

let
  cargoDeps = if cargoVendorDir == null
    then fetchcargo {
        inherit name src srcs sourceRoot cargoUpdateHook;
        patches = cargoPatches;
        sha256 = cargoSha256;
      }
    else null;

  setupVendorDir = if cargoVendorDir == null
    then ''
      unpackFile "$cargoDeps"
      cargoDepsCopy=$(stripHash $(basename $cargoDeps))
      chmod -R +w "$cargoDepsCopy"
    ''
    else ''
      cargoDepsCopy="$sourceRoot/${cargoVendorDir}"
    '';

  ccBinFor = platform: let
    cc = if platform == stdenv.buildPlatform then buildPackages.stdenv.cc else stdenv.cc;
    ccBin = suffix: "${cc}/bin/${cc.targetPrefix}${suffix}";
  in {
    cc = ccBin "cc";
    cxx = ccBin "c++";
    ar = "${cc.bintools.bintools}/bin/${cc.targetPrefix}ar";
  };
  cargoTargetVar = target: suffix: with stdenv.lib;
    "CARGO_TARGET_${replaceStrings [ "-" ] [ "_" ] (toUpper target)}_${suffix}";

  buildCcBin = ccBinFor stdenv.buildPlatform;
  hostCcBin = ccBinFor stdenv.hostPlatform;

  ccEnv = {
    "AR_${stdenv.buildPlatform.config}" = buildCcBin.ar;
    "CC_${stdenv.buildPlatform.config}" = buildCcBin.cc;
    "CXX_${stdenv.buildPlatform.config}" = buildCcBin.cxx;
    ${cargoTargetVar stdenv.buildPlatform.config "LINKER"} = buildCcBin.cc;
    ${cargoTargetVar stdenv.buildPlatform.config "AR"} = buildCcBin.ar;
  } // stdenv.lib.optionalAttrs (stdenv.buildPlatform.config != stdenv.hostPlatform.config) {
    "AR_${stdenv.hostPlatform.config}" = hostCcBin.ar;
    "CC_${stdenv.hostPlatform.config}" = hostCcBin.cc;
    "CXX_${stdenv.hostPlatform.config}" = hostCcBin.cxx;
    ${cargoTargetVar stdenv.hostPlatform.config "LINKER"} = hostCcBin.cc;
    ${cargoTargetVar stdenv.hostPlatform.config "AR"} = hostCcBin.ar;
  };

  # sidestep assumptions currently made about "target/release"
  cargoTargetDir = "target/nix-cargo";
  releaseDir = "${cargoTargetDir}/${stdenv.hostPlatform.config}/${buildType}";

in stdenv.mkDerivation (args // ccEnv // {
  inherit cargoDeps;

  patchRegistryDeps = ./patch-registry-deps;

  nativeBuildInputs = [ cargo rustc git cacert ] ++ nativeBuildInputs;
  inherit buildInputs;

  patches = cargoPatches ++ patches;

  PKG_CONFIG_ALLOW_CROSS =
    if stdenv.buildPlatform != stdenv.hostPlatform then 1 else 0;

  inherit releaseDir buildType;

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

    unset cargoDepsCopy

    export RUST_LOG=${logLevel}
  '' + (args.postUnpack or "");

  configurePhase = args.configurePhase or ''
    runHook preConfigure
    mkdir -p .cargo
    cat >> .cargo/config <<EOF
    [build]
    target-dir = "$(pwd)/${cargoTargetDir}"
    EOF
    cat .cargo/config

    if [[ ! -e target/release ]]; then
      # for out-of-tree derivations that may have hardcoded "target/release"
      mkdir -p target
      ln -sr $releaseDir target/release
    fi

    runHook postConfigure
  '';

  buildPhase = with builtins; args.buildPhase or ''
    runHook preBuild

    (
    set -x
      cargo build \
        ${stdenv.lib.optionalString (buildType != "debug") "--${buildType}"} \
        --target ${stdenv.hostPlatform.config} \
        --frozen ${concatStringsSep " " cargoBuildFlags}
    )

    runHook postBuild
  '';

  checkPhase = args.checkPhase or ''
    runHook preCheck
    echo "Running cargo test"
    cargo test
    runHook postCheck
  '';

  doCheck = args.doCheck or true;

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
})
