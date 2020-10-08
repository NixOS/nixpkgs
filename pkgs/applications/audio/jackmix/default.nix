{ stdenv, fetchurl, pkgconfig, sconsPackages, qt4, lash, libjack2, jack ? libjack2, alsaLib }:

stdenv.mkDerivation {
  name = "jackmix-0.5.2";
  src = fetchurl {
    url = "https://github.com/kampfschlaefer/jackmix/archive/v0.5.2.tar.gz";
    sha256 = "18f5v7g66mgarhs476frvayhch7fy4nyjf2xivixc061ipn0m82j";
  };

  patches = [ ./no_error.patch ];

  nativeBuildInputs = [ sconsPackages.scons_3_1_2 pkgconfig ];
  buildInputs = [
    qt4
    lash
    jack
    alsaLib
  ];

  installPhase = ''
    install -D jackmix/jackmix $out/bin/jackmix
  '';

  meta = {
    description = "Matrix-Mixer for the Jack-Audio-connection-Kit";
    homepage = "http://www.arnoldarts.de/jackmix/";
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.kampfschlaefer ];
    platforms = stdenv.lib.platforms.linux;
  };
}
