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

  # TODO: Probably not the best way to do this, but it should work for now
  prePatch = ''
    for dir in ../deps/registry/src/*/pkg-config-*; do
        [ -d "$dir" ] || continue

        substituteInPlace "$dir/src/lib.rs" \
            --replace '"/usr"' '"/nix/store/"'
    done
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
