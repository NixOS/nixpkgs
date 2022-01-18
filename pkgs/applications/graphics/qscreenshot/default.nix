{ lib, stdenv, fetchurl, dos2unix, which, qt, Carbon }:

stdenv.mkDerivation rec {
  pname = "qscreenshot";
  version = "1.0";

  src = fetchurl {
    url = "mirror://sourceforge/qscreenshot/qscreenshot-${version}-src.tar.gz";
    sha256 = "1spj5fg2l8p5bk81xsv6hqn1kcrdiy54w19jsfb7g5i94vcb1pcx";
  };

  buildInputs = [ dos2unix which qt ]
    ++ lib.optional stdenv.isDarwin Carbon;

  # Remove carriage returns that cause /bin/sh to abort
  preConfigure = ''
    dos2unix configure
    sed -i "s|lrelease-qt4|lrelease|" src/src.pro
  '';

  meta = with lib; {
    description = "Simple creation and editing of screenshots";
    homepage = "https://sourceforge.net/projects/qscreenshot/";
    license = licenses.gpl2;
    platforms = platforms.all;
    maintainers = [ maintainers.bjornfor ];
  };
}
