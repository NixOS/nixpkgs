{ stdenv, buildGoPackage, fetchgit }:

buildGoPackage rec {
  pname = "wego";
  version = "unstable-2019-02-11";
  rev = "994e4f141759a1070d7b0c8fbe5fad2cc7ee7d45";

  goPackagePath = "github.com/schachmat/wego";

  src = fetchgit {
    inherit rev;
    url = "https://github.com/schachmat/wego";
    sha256 = "1affzwi5rbp4zkirhmby8bvlhsafw7a4rs27caqwyj8g3jhczmhy";
  };

  goDeps = ./deps.nix;

  meta = {
    license = stdenv.lib.licenses.isc;
    homepage = "https://github.com/schachmat/wego";
    description = "Weather app for the terminal";
  };
}
