{ stdenv, fetchurl
, openssl, qt5, libGLU_combined, zlib, pkgconfig, libav
}:

stdenv.mkDerivation rec {
  name = "makemkv-${ver}";
  ver = "1.12.2";
  builder = ./builder.sh;

  src_bin = fetchurl {
    url = "http://www.makemkv.com/download/makemkv-bin-${ver}.tar.gz";
    sha256 = "0ylybq0776am5yy064b55q0jja1q1p9dscwmn7f1p3igzv15rypj";
  };

  src_oss = fetchurl {
    url = "http://www.makemkv.com/download/makemkv-oss-${ver}.tar.gz";
    sha256 = "063rgb88zbh4zwysyhjn4awykcnc90qgsx6d8ggm27wy849306v1";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [openssl qt5.qtbase libGLU_combined zlib libav];

  libPath = stdenv.lib.makeLibraryPath [stdenv.cc.cc openssl libGLU_combined qt5.qtbase zlib ]
          + ":" + stdenv.cc.cc + "/lib64";

  meta = with stdenv.lib; {
    description = "Convert blu-ray and dvd to mkv";
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
