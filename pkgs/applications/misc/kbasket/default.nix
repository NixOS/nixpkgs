{stdenv, fetchurl, kdelibs, x11, zlib, libpng, libjpeg, perl, qt3, gpgme,
libgpgerror}:

stdenv.mkDerivation {
  name = "kbasket-1.0.3.1";
  
  src = fetchurl {
    url = http://basket.kde.org/downloads/basket-1.0.3.1.tar.gz;
    sha256 = "1dgghxmabc3bz1644p6dfnjdjbm80jj6fh343r22nkp703q6fqbk";
  };
  
  buildInputs = [kdelibs x11 zlib libjpeg libpng perl qt3 gpgme libgpgerror];

  configureFlags = [ "--without-arts" "--with-extra-includes=${libjpeg}/include" "--x-libraries=${x11}/lib" ];

  meta = {
    description = "Multi-purpose note-taking application";
    homepage = http://kbasket.kde.org/;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
    license = "GPLv2+";
  };
}
