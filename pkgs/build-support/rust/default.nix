{ stdenv, cacert, git, rust, rustRegistry }:
{ name, depsSha256
, src ? null
, srcs ? null
, sourceRoot ? null
, logLevel ? ""
, buildInputs ? []
, cargoUpdateHook ? ""
, ... } @ args:

let
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

  configurePhase = args.configurePhase or "true";

  postUnpack = ''
    echo "Using cargo deps from $cargoDeps"

    cp -r "$cargoDeps" deps
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

  buildPhase = args.buildPhase or ''
    echo "Running cargo build --release"
    cargo build --release
  '';

  checkPhase = args.checkPhase or ''
    echo "Running cargo test"
    cargo test
  '';

  doCheck = args.doCheck or true;

  installPhase = args.installPhase or ''
    mkdir -p $out/bin
    for f in $(find target/release -maxdepth 1 -type f); do
      cp $f $out/bin
    done;
  '';
})
