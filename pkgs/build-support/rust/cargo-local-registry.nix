{ fetchurl, stdenv }:

let
  version = "0.1.4";
  platform =
    if stdenv.system == "x86_64-linux"
    then "x86_64-unknown-linux-musl"
    else if stdenv.system == "x86_64-darwin"
    then "x86_64-apple-darwin"
    else throw "missing bootstrap url for platform ${stdenv.system}";

  # fetch hashes by patching print-hashes.sh to not use the "$DATE" variable
  # then running `print-hashes.sh 1.16.0`
  hash =
    if stdenv.system == "x86_64-linux"
    then "7716524846297abc6e8a7b26c57f56b1e0c2b261a6d0583e78f2a8fd60b33695"
    else if stdenv.system == "x86_64-darwin"
    then "439ff0303bc17fd8587196f0658ae4430850a906e67648f9fde047c9c7c75998"
    else throw "missing bootstrap hash for platform ${stdenv.system}";
in stdenv.mkDerivation {
  name = "cargo-local-registry-${version}";

  src = fetchurl {
     url = "https://github.com/alexcrichton/cargo-local-registry/releases/download/${version}/cargo-local-registry-${version}-${platform}.tar.gz";
     sha256 = hash;
  };

  phases = "unpackPhase installPhase";

  installPhase = ''
    install -Dm755 cargo-local-registry $out/bin/cargo-local-registry
  '';
}
