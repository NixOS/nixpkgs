{ stdenv, cacert, cargo, rustc }:
{ name, src, sha256, buildInputs ? [] }:

let
  fetchcargo = import ./fetchcargo.nix { inherit stdenv cacert cargo; };
  deps = fetchcargo { inherit name src sha256; };

in stdenv.mkDerivation {
  inherit name src;

  buildInputs = [ cargo rustc ] ++ buildInputs;

  configurePhase = "true";

  buildPhase = ''
    echo "Using cargo deps from ${deps}"
    cp -r ${deps} deps
    chmod +w deps -R
    export HOME=$(realpath deps)
    echo "Running cargo build"
    cargo build --release
  '';

  installPhase = ''
    mkdir -p $out/bin
    for f in $(find target/release -maxdepth 1 -type f); do
      cp $f $out/bin
    done;
  '';

}