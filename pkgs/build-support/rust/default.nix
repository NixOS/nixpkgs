{ stdenv, cacert, git, cargo, rustc, cargo-vendor, fetchcargo, python3, buildPackages }:

{ name, cargoSha256 ? "unset"
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

, cargoVendorDir ? null
, ... } @ args:

assert cargoVendorDir == null -> cargoSha256 != "unset";

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

  ccForBuild="${buildPackages.stdenv.cc}/bin/${buildPackages.stdenv.cc.targetPrefix}cc";
  cxxForBuild="${buildPackages.stdenv.cc}/bin/${buildPackages.stdenv.cc.targetPrefix}cxx";
  ccForHost="${stdenv.cc}/bin/${stdenv.cc.targetPrefix}cc";
  cxxForHost="${stdenv.cc}/bin/${stdenv.cc.targetPrefix}cxx";
  releaseDir = "target/${stdenv.hostPlatform.config}/release";

in stdenv.mkDerivation (args // {
  inherit cargoDeps;

  patchRegistryDeps = ./patch-registry-deps;

  nativeBuildInputs = [ cargo rustc git cacert ] ++ nativeBuildInputs;
  inherit buildInputs;

  patches = cargoPatches ++ patches;

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
    mkdir .cargo
    cat > .cargo/config <<'EOF'
    [target."${stdenv.buildPlatform.config}"]
    "linker" = "${ccForBuild}"
    ${stdenv.lib.optionalString (stdenv.buildPlatform.config != stdenv.hostPlatform.config) ''
    [target."${stdenv.hostPlatform.config}"]
    "linker" = "${ccForHost}"
    ''}
    EOF
    cat .cargo/config
    runHook postConfigure
  '';

  buildPhase = with builtins; args.buildPhase or ''
    runHook preBuild
    echo "Running cargo build --target ${stdenv.hostPlatform.config} --release ${concatStringsSep " " cargoBuildFlags}"
    env \
      "CC_${stdenv.buildPlatform.config}"="${ccForBuild}" \
      "CXX_${stdenv.buildPlatform.config}"="${cxxForBuild}" \
      "CC_${stdenv.hostPlatform.config}"="${ccForHost}" \
      "CXX_${stdenv.hostPlatform.config}"="${cxxForHost}" \
      cargo build \
        --release \
        --target ${stdenv.hostPlatform.config} \
        --frozen ${concatStringsSep " " cargoBuildFlags}
    runHook postBuild
  '';

  checkPhase = args.checkPhase or ''
    runHook preCheck
    echo "Running cargo test"
    cargo test
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
})
