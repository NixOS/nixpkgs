{ stdenv, fetchFromGitHub, getopt, which, pkgconfig, gtk3 } :

stdenv.mkDerivation (rec {
  name = "pqiv-${version}";
  version = "2.10.1";

  src = fetchFromGitHub {
    owner = "phillipberndt";
    repo = "pqiv";
    rev = version;
    sha256 = "06blqckj3bpbi2kl5ndv2d10r7nw62r386kfwrkic9amynlv9gki";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ getopt which gtk3 ];

  prePatch = "patchShebangs .";

  meta = with stdenv.lib; {
    description = "Powerful image viewer with minimal UI";
    homepage = http://www.pberndt.com/Programme/Linux/pqiv;
    license = licenses.gpl3;
    maintainers = [ maintainers.ndowens ];
    platforms = platforms.linux;
  };
})
