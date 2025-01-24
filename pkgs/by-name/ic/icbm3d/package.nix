{
  lib,
  stdenv,
  fetchurl,
  libX11,
}:

stdenv.mkDerivation rec {
  pname = "icbm3d";
  version = "0.4";
  src = fetchurl {
    url = "ftp://ftp.tuxpaint.org/unix/x/icbm3d/icbm3d.${version}.tar.gz";
    sha256 = "1z9q01mj0v9qbwby5cajjc9wpvdw2ma5v1r639vraxpl9qairm4s";
  };

  buildInputs = [ libX11 ];

  installPhase = ''
    mkdir -p $out/bin
    cp icbm3d $out/bin
  '';

  meta = {
    homepage = "http://www.newbreedsoftware.com/icbm3d/";
    description = "3D vector-based clone of the atari game Missile Command";
    mainProgram = "icbm3d";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
}
