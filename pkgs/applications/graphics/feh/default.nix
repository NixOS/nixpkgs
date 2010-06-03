{ stdenv, fetchurl, x11, imlib2, libjpeg, libpng, giblib
, libXinerama }:

stdenv.mkDerivation {
  name = "feh-1.6";

  src = fetchurl {
    url = https://derf.homelinux.org/projects/feh/feh-1.6.tar.bz2;
    sha256 = "0wkgdxvl0kdcwab815gw0xk3iniain6l3b1x4d4kclf170wcnjqi";
  };

  buildInputs = [x11 imlib2 giblib libjpeg libpng libXinerama];

  preBuild = ''
    makeFlags="PREFIX=$out"
  '';

  meta = {
    description = "A light-weight image viewer";
    homepage = https://derf.homelinux.org/projects/feh/;
    license = "BSD";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
