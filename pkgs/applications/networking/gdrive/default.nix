{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name    = "gdrive-${version}";
  version = "2.1.0";
  rev     = "${version}";

  goPackagePath = "github.com/prasmussen/gdrive";

  src = fetchFromGitHub {
    owner  = "prasmussen";
    repo   = "gdrive";
    sha256 = "0ywm4gdmrqzb1a99vg66a641r74p7lglavcpgkm6cc2gdwzjjfg7";
    inherit rev;
  };

  meta = with stdenv.lib; {
    homepage    = https://github.com/prasmussen/gdrive;
    description = "A command line utility for interacting with Google Drive";
    platforms   = platforms.linux;
    license     = licenses.mit;
    maintainers = [ maintainers.rzetterberg ];
  };
}
