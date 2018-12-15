{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name    = "exercism-${version}";
  version = "3.0.9";

  goPackagePath = "github.com/exercism/cli";

  src = fetchFromGitHub {
    owner  = "exercism";
    repo   = "cli";
    rev    = "v${version}";
    sha256 = "0nr3dzipylicrbplh25dw0w84qklr0xcyq442i9aswzibqrb2vc6";
  };

  goDeps = ./deps.nix;

  meta = with stdenv.lib; {
   inherit (src.meta) homepage;
   description = "A Go based command line tool for exercism.io";
   license     = licenses.mit;
   maintainers = [ maintainers.rbasso ];
  };
}
