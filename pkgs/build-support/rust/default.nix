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

  # The following is the directory name cargo creates when the registry index
  # URL is file:///dev/null
  #
  # It's OK to use /dev/null as the URL because by the time we do this, cargo
  # won't attempt to update the registry anymore, so the URL is more or less
  # irrelevant
  registryIndexDirName = "-ba82b75dd6681d6f";

in stdenv.mkDerivation (args // {
  inherit cargoDeps rustRegistry;

  patchRegistryDeps = ./patch-registry-deps;

  buildInputs = [ git cargo rustc ] ++ buildInputs;

  configurePhase = args.configurePhase or "true";

  postUnpack = ''
    echo "Using cargo deps from $cargoDeps"

    cp -r "$cargoDeps" deps
    chmod +w deps -R

    cat <<EOF > deps/config
    [registry]
    index = "file:///dev/null"
    EOF

    echo "Using rust registry from $rustRegistry"

    ln -s "$rustRegistry" "deps/registry/index/${registryIndexDirName}"

    export CARGO_HOME="$(realpath deps)"

    # Retrieved the Cargo.lock file which we saved during the fetch
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

        cd ../deps/registry/src/*

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
