{ stdenv, cacert, git, cargo, rustc, cargo-vendor, fetchcargo, python3 }:

{ name, cargoSha256 ? "unset"
, src ? null
, srcs ? null
, cargoPatches ? []
, patches ? []
, sourceRoot ? null
, logLevel ? ""
, buildInputs ? []
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

in stdenv.mkDerivation (args // {
  inherit cargoDeps;

  patchRegistryDeps = ./patch-registry-deps;

  buildInputs = [ cacert git cargo rustc ] ++ buildInputs;

  patches = cargoPatches ++ patches;

  configurePhase = args.configurePhase or ''
    runHook preConfigure
    # noop
    runHook postConfigure
  '';

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

  buildPhase = with builtins; args.buildPhase or ''
    runHook preBuild
    echo "Running cargo build --release ${concatStringsSep " " cargoBuildFlags}"
    cargo build --release --frozen ${concatStringsSep " " cargoBuildFlags}
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
    find target/release -maxdepth 1 -type f -executable ! \( -regex ".*\.\(so.[0-9.]+\|so\|a\|dylib\)" \) -print0 | xargs -r -0 cp -t $out/bin
    find target/release -maxdepth 1 -regex ".*\.\(so.[0-9.]+\|so\|a\|dylib\)" -print0 | xargs -r -0 cp -t $out/lib
    rmdir --ignore-fail-on-non-empty $out/lib $out/bin
    runHook postInstall
  '';

  passthru = { inherit cargoDeps; } // (args.passthru or {});
})
