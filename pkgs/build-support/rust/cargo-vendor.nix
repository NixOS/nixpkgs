{ fetchurl, stdenv }:
let
  inherit (stdenv) system;

  version = "0.1.13";

  hashes = {
    x86_64-linux = "1znv8hm4z4bfb6kncf95jv6h20qkmz3yhhr8f4vz2wamynklm9pr";
    x86_64-darwin = "0hcib4yli216qknjv7r2w8afakhl9yj19yyppp12c1p4pxhr1qr6";
  };
  hash = hashes. ${system} or badSystem;

  badSystem = throw "missing bootstrap hash for platform ${system}";

  platforms = {
    x86_64-linux = "x86_64-unknown-linux-musl";
    x86_64-darwin = "x86_64-apple-darwin";
  };
  platform = platforms . ${system} or badSystem;

in stdenv.mkDerivation {
  name = "cargo-vendor-${version}";

  src = fetchurl {
     url = "https://github.com/alexcrichton/cargo-vendor/releases/download/${version}/cargo-vendor-${version}-${platform}.tar.gz";
     sha256 = hash;
  };

  phases = "unpackPhase installPhase";

  installPhase = ''
    install -Dm755 cargo-vendor $out/bin/cargo-vendor
  '';
}
