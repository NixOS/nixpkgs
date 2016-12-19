{ stdenv, fetchurl, pkgs, jack ? pkgs.libjack2 }:

stdenv.mkDerivation rec {
  name = "jackmix-0.5.2";
  src = fetchurl {
    url = https://github.com/kampfschlaefer/jackmix/archive/v0.5.2.tar.gz;
    sha256 = "18f5v7g66mgarhs476frvayhch7fy4nyjf2xivixc061ipn0m82j";
  };

  buildInputs = [
    pkgs.pkgconfig
    pkgs.scons
    pkgs.kde4.qt4
    pkgs.lash
    jack
  ];

  buildPhase = ''
    scons
  '';
  installPhase = ''
    mkdir -p $out/bin
    cp jackmix/jackmix $out/bin
  '';

  meta = {
    description = "Matrix-Mixer for the Jack-Audio-connection-Kit";
    homepage = http://www.arnoldarts.de/jackmix/;
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.kampfschlaefer ];
    platforms = stdenv.lib.platforms.linux;
  };
}


