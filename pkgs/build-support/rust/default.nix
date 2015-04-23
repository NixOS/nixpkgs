{ stdenv, cacert, git, rustc, cargo, rustRegistry }:
{ name, src, depsSha256, buildInputs ? [], cargoUpdateHook ? "", ... } @ args:

let
  fetchDeps = import ./fetchcargo.nix {
    inherit stdenv cacert git rustc cargo rustRegistry;
  };

  cargoDeps = fetchDeps {
    inherit name src cargoUpdateHook;
    sha256 = depsSha256;
  };

in stdenv.mkDerivation (args // {
  inherit cargoDeps rustRegistry cargoUpdateHook;

  patchRegistryDeps = ./patch-registry-deps;

  buildInputs = [ git cargo rustc ] ++ buildInputs;

  configurePhase = args.configurePhase or "true";

  postUnpack = ''
    echo "Using cargo deps from $cargoDeps"
    cp -r $cargoDeps deps
    chmod +w deps -R

    export CARGO_HOME=$(realpath deps)

    echo "Using rust registry from $rustRegistry"
    (
        cd $sourceRoot
        ln -s $rustRegistry ./cargo-rust-registry

        substituteInPlace Cargo.lock \
            --replace "registry+https://github.com/rust-lang/crates.io-index" \
                      "registry+file:///proc/self/cwd/cargo-rust-registry"

        eval "$cargoUpdateHook"

        cargo fetch
        cargo clean
    )
  '' + (args.postUnpack or "");

  prePatch = ''
    # Patch registry dependencies, using the scripts in $patchRegistryDeps
    (
        cd ../deps/registry/src/*

        set -euo pipefail

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
