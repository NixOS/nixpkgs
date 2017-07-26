{ stdenv, fetchurl, file, pkgconfig, libpng, nasm }:

stdenv.mkDerivation rec {
  version = "3.2";
  name = "mozjpeg-${version}";

  src = fetchurl {
    url = "https://github.com/mozilla/mozjpeg/releases/download/v${version}/mozjpeg-${version}-release-source.tar.gz";
    sha256 = "0wvv5qh1jasz8apq93c3j9d5wd22j7lld9dr06p76yj4mpnc3v4a";
  };

  postPatch = ''
    sed -i -e "s!/usr/bin/file!${file}/bin/file!g" configure
  '';

  buildInputs = [ libpng pkgconfig nasm ];

  meta = {
    description = "Mozilla JPEG Encoder Project";
    longDescription = ''
      This project's goal is to reduce the size of JPEG files without reducing quality or compatibility with the
      vast majority of the world's deployed decoders.

      The idea is to reduce transfer times for JPEGs on the Web, thus reducing page load times.
    '';
    homepage = https://github.com/mozilla/mozjpeg ;
    license = stdenv.lib.licenses.bsd3;
    maintainers = [ stdenv.lib.maintainers.aristid ];
    platforms = stdenv.lib.platforms.all;
  };
}
