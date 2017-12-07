{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name    = "exercism-${version}";
  version = "2.4.1";

  goPackagePath = "github.com/exercism/cli";

  src = fetchFromGitHub {
    owner  = "exercism";
    repo   = "cli";
    rev    = "v${version}";
    sha256 = "1nab4459zi2gkh18k9vsm54bz39c2sb60v2xy0i72j1vd99axjjj";
  };

  meta = with stdenv.lib; {
   description = "A Go based command line tool for exercism.io";
   homepage    = http://exercism.io/cli;
   license     = licenses.mit;
   maintainers = [ maintainers.rbasso ];
   platforms   = platforms.unix;
  };
}
