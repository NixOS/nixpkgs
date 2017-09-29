{ stdenv, callPackage, path, cacert, git, rust, rustRegistry }:

let
  rustRegistry' = rustRegistry;
in
{ name, depsSha256
, rustRegistry ? rustRegistry'
, src ? null
, srcs ? null
, sourceRoot ? null
, logLevel ? ""
, buildInputs ? []
, cargoUpdateHook ? ""
, cargoDepsHook ? ""
, cargoBuildFlags ? []
, ... } @ args:

let
  lib = stdenv.lib;

  fetchDeps = import ./fetchcargo.nix {
    inherit stdenv cacert git rust rustRegistry;
  };

  cargoDeps = fetchDeps {
    inherit name src srcs sourceRoot cargoUpdateHook;
    sha256 = depsSha256;
  };

in stdenv.mkDerivation (args // {
  inherit cargoDeps rustRegistry;

  patchRegistryDeps = ./patch-registry-deps;

  buildInputs = [ git rust.cargo rust.rustc ] ++ buildInputs;

  configurePhase = args.configurePhase or ''
    runHook preConfigure
    # noop
    runHook postConfigure
  '';

  postUnpack = ''
    eval "$cargoDepsHook"

    echo "Using cargo deps from $cargoDeps"

    cp -a "$cargoDeps" deps
    chmod +w deps -R

    # It's OK to use /dev/null as the URL because by the time we do this, cargo
    # won't attempt to update the registry anymore, so the URL is more or less
    # irrelevant

    cat <<EOF > deps/config
    [registry]
    index = "file:///dev/null"
    EOF

    export CARGO_HOME="$(realpath deps)"
    export RUST_LOG=${logLevel}
    export SSL_CERT_FILE=${cacert}/etc/ssl/certs/ca-bundle.crt

    # Let's find out which $indexHash cargo uses for file:///dev/null
    (cd $sourceRoot && cargo fetch &>/dev/null) || true
    cd deps
    indexHash="$(basename $(echo registry/index/*))"

    echo "Using indexHash '$indexHash'"

    rm -rf -- "registry/cache/$indexHash" \
              "registry/index/$indexHash"

    mv registry/cache/HASH "registry/cache/$indexHash"

    echo "Using rust registry from $rustRegistry"
    ln -s "$rustRegistry" "registry/index/$indexHash"

    # Retrieved the Cargo.lock file which we saved during the fetch
    cd ..
    mv deps/Cargo.lock $sourceRoot/

    (
        cd $sourceRoot

        cargo fetch
        cargo clean
    )
  '' + (args.postUnpack or "");

  prePatch = ''
    # Patch registry dependencies, using the scripts in $patchRegistryDeps
    (
        set -euo pipefail

        cd $NIX_BUILD_TOP/deps/registry/src/*

        for script in $patchRegistryDeps/*; do
          # Run in a subshell so that directory changes and shell options don't
          # affect any following commands

          ( . $script)
        done
    )
  '' + (args.prePatch or "");

  buildPhase = with builtins; args.buildPhase or ''
    runHook preBuild
    echo "Running cargo build --release ${concatStringsSep " " cargoBuildFlags}"
    cargo build --release ${concatStringsSep " " cargoBuildFlags}
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
    mkdir -p $out/bin
    find target/release -maxdepth 1 -executable -exec cp "{}" $out/bin \;
    runHook postInstall
  '';
})
