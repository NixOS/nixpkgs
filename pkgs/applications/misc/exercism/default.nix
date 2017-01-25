{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name    = "exercism-${version}";
  version = "2.3.0";

  goPackagePath = "github.com/exercism/cli";

  src = fetchFromGitHub {
    owner  = "exercism";
    repo   = "cli";
    rev    = "v${version}";
    sha256 = "1zhvvmsh5kw739kylk0bqj1wa6vjyahz43dlxdpv42h8gfiiksf5";
  };

  meta = with stdenv.lib; {
   description = "A Go based command line tool for exercism.io";
   homepage    = http://exercism.io/cli;
   license     = licenses.mit;
   maintainers = [ maintainers.rbasso ];
   platforms   = platforms.unix;
  };
}
