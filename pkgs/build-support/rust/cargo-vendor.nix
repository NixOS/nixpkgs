{ fetchurl, stdenv }:
let
  inherit (stdenv) system;

  version = "0.1.12";

  hashes = {
    x86_64-linux = "1hxlavcxy374yypfamlkygjg662lhll8j434qcvdawkvlidg5ii5";
    x86_64-darwin = "1jkvhh710gwjnnjx59kaplx2ncfvkx9agfa76rr94sbjqq4igddm";
  };
  hash = hashes. ${system} or (throw "missing bootstrap hash for platform ${system}");

  platforms = {
    x86_64-linux = "x86_64-unknown-linux-musl";
    x86_64-darwin = "x86_64-apple-darwin";
  };
  platform = platforms . ${system};

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
