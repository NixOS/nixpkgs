{stdenv, fetchurl, perl, x11, libxml2, libjpeg, libpng, openssl, qt, dclib}:

stdenv.mkDerivation {
  name = "valknut-0.3.7";
  builder = ./builder.sh;

  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/valknut-0.3.7.tar.bz2;
    md5 = "848f9b3f25af15c3f1837133ac4b9415";
  };

  buildInputs = [perl x11 libxml2 libjpeg libpng openssl qt dclib];
  inherit openssl;
}
