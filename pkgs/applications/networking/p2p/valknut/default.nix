{stdenv, fetchurl, perl, x11, libxml2, libjpeg, libpng, openssl, qt3, dclib}:

stdenv.mkDerivation {
  name = "valknut-0.3.7";
  builder = ./builder.sh;

  src = fetchurl {
    url = http://download.berlios.de/dcgui/valknut-0.3.7.tar.bz2;
    md5 = "848f9b3f25af15c3f1837133ac4b9415";
  };

  buildInputs = [perl x11 libxml2 libjpeg libpng openssl qt3 dclib];
  inherit openssl;
}
