{ stdenv, fetchurl
, openssl, qt4, mesa, zlib, pkgconfig, libav
}:

stdenv.mkDerivation rec {
  name = "makemkv-${ver}";
  ver = "1.8.14";
  builder = ./builder.sh;

  src_bin = fetchurl {
    url = "http://www.makemkv.com/download/makemkv-bin-${ver}.tar.gz";
    sha256 = "1kjxawqh6xnjcgvaqy7idg8k0g3zqrr1w5r2r3bf11pg0h1ys5l5";
  };

  src_oss = fetchurl { 
    url = "http://www.makemkv.com/download/makemkv-oss-${ver}.tar.gz";
    sha256 = "0cq3h45yyqma0kzi594dz0gbgjf3gyjcgxkiynifz3hacrbxbnd5";
  };

  buildInputs = [openssl qt4 mesa zlib pkgconfig libav];

  libPath = stdenv.lib.makeLibraryPath [stdenv.gcc.gcc openssl mesa qt4 zlib ] 
          + ":" + stdenv.gcc.gcc + "/lib64";

  meta = {
    description = "convert blu-ray and dvd to mkv";
    longDescription = ''
      makemkv is a one-click QT application that transcodes an encrypted
      blu-ray or DVD disc into a more portable set of mkv files, preserving
      subtitles, chapter marks, all video and audio tracks.

      Program is time-limited -- it will stop functioning after 60 days. You
      can always download the latest version from makemkv.com that will reset the
      expiration date.
    '';
    license = stdenv.lib.licenses.unfree;
    homepage = http://makemkv.com;
  };
}
