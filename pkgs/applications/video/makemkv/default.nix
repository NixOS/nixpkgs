{ stdenv, fetchurl
, openssl, qt4, mesa, zlib, pkgconfig, libav
}:

stdenv.mkDerivation rec {
  name = "makemkv-${ver}";
  ver = "1.9.1";
  builder = ./builder.sh;

  src_bin = fetchurl {
    url = "http://www.makemkv.com/download/makemkv-bin-${ver}.tar.gz";
    sha256 = "0458ilchi64q8yw4kxck565anpn6lf5awrnkz17bk38qdgp0i2nq";
  };

  src_oss = fetchurl {
    url = "http://www.makemkv.com/download/makemkv-oss-${ver}.tar.gz";
    sha256 = "1x4mjx32839gf9k2zrjz2250valnqcaa2q89kc7sipgsl4b7wrr2";
  };

  buildInputs = [openssl qt4 mesa zlib pkgconfig libav];

  libPath = stdenv.lib.makeLibraryPath [stdenv.cc.cc openssl mesa qt4 zlib ]
          + ":" + stdenv.cc.cc + "/lib64";

  meta = with stdenv.lib; {
    description = "convert blu-ray and dvd to mkv";
    longDescription = ''
      makemkv is a one-click QT application that transcodes an encrypted
      blu-ray or DVD disc into a more portable set of mkv files, preserving
      subtitles, chapter marks, all video and audio tracks.

      Program is time-limited -- it will stop functioning after 60 days. You
      can always download the latest version from makemkv.com that will reset the
      expiration date.
    '';
    license = licenses.unfree;
    homepage = http://makemkv.com;
    maintainers = [ maintainers.titanous ];
  };
}
