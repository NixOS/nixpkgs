{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name    = "exercism-${version}";
  version = "3.0.6";

  goPackagePath = "github.com/exercism/cli";

  src = fetchFromGitHub {
    owner  = "exercism";
    repo   = "cli";
    rev    = "v${version}";
    sha256 = "0xr5bqzm0md1vllnr384k92k7w1nxzw9lhqgm23zkxx5a4vqzy56";
  };

  goDeps = ./deps.nix;

  meta = with stdenv.lib; {
   inherit (src.meta) homepage;
   description = "A Go based command line tool for exercism.io";
   license     = licenses.mit;
   maintainers = [ maintainers.rbasso ];
  };
}
