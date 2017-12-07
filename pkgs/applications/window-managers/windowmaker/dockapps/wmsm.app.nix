{ stdenv, fetchurl, pkgconfig, libX11, libXpm, libXext }:

stdenv.mkDerivation {
  name = "wmsm.app-0.2.1";
  src = fetchurl {
     url = http://linux-bsd-unix.strefa.pl/wmsm.app-0.2.1.tar.bz2;
     sha256 = "369a8f2e5673c6b7ab0cf85166f38fbf553dd966c3c1cfeec0e32837defd32c7";
  };

  buildInputs = [ pkgconfig libX11 libXpm libXext ];

  postUnpack = "sourceRoot=\${sourceRoot}/wmsm";

  installPhase = ''
    substituteInPlace Makefile --replace "PREFIX	= /usr/X11R6/bin" "" --replace "/usr/bin/install" "install"
    mkdir -pv $out/bin;
    make PREFIX=$out/bin install;
    '';

  meta = {
    description = "System monitor for Windowmaker";
    homepage = http://linux-bsd-unix.strefa.pl;
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.bstrik ];
  };
}
