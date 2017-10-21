{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name    = "exercism-${version}";
  version = "2.4.0";

  goPackagePath = "github.com/exercism/cli";

  src = fetchFromGitHub {
    owner  = "exercism";
    repo   = "cli";
    rev    = "v${version}";
    sha256 = "1hl13sr4ymqg9sjhkxdmhf8cfw69cic3bysw34xfv2j6bjjxfwaa";
  };

  meta = with stdenv.lib; {
   description = "A Go based command line tool for exercism.io";
   homepage    = http://exercism.io/cli;
   license     = licenses.mit;
   maintainers = [ maintainers.rbasso ];
   platforms   = platforms.unix;
  };
}
