{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "exercism";
  version = "3.0.12";

  goPackagePath = "github.com/exercism/cli";

  src = fetchFromGitHub {
    owner  = "exercism";
    repo   = "cli";
    rev    = "v${version}";
    sha256 = "1xvxcl7j5izx5lgmjd97zd28lg2sydwgbgn2cnisz5r0d27pj3ra";
  };

  goDeps = ./deps.nix;

  meta = with stdenv.lib; {
   inherit (src.meta) homepage;
   description = "A Go based command line tool for exercism.io";
   license     = licenses.mit;
   maintainers = [ maintainers.rbasso ];
  };
}
