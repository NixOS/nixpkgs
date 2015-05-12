{ stdenv, cacert, git, rustc, cargo, rustRegistry }:
{ name, src, depsSha256, buildInputs ? [], ... } @ args:

let
  fetchDeps = import ./fetchcargo.nix {
    inherit stdenv cacert git rustc cargo rustRegistry;
  };

  cargoDeps = fetchDeps {
    inherit name src;
    sha256 = depsSha256;
  };

in stdenv.mkDerivation (args // {
  inherit cargoDeps rustRegistry;

  buildInputs = [ git cargo rustc ] ++ buildInputs;

  configurePhase = args.configurePhase or "true";

  postUnpack = ''
    echo "Using rust registry from $rustRegistry"
    (
        cd $sourceRoot
        ln -s $rustRegistry ./cargo-rust-registry
        cargo clean
        cargo fetch
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
    echo "Running cargo build"
    cargo build --release
  '';

  installPhase = args.installPhase or ''
    mkdir -p $out/bin
    for f in $(find target/release -maxdepth 1 -type f); do
      cp $f $out/bin
    done;
  '';
})
