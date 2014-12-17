{ stdenv, fetchurl
, openssl, qt4, mesa, zlib, pkgconfig, libav
}:

stdenv.mkDerivation rec {
  name = "makemkv-${ver}";
  ver = "1.9.0";
  builder = ./builder.sh;

  src_bin = fetchurl {
    url = "http://www.makemkv.com/download/makemkv-bin-${ver}.tar.gz";
    sha256 = "1rcvg7a1h59mfwsl5w0fr89m101pkqm9vgj06dl91hkgp5nh3wah";
  };

  src_oss = fetchurl { 
    url = "http://www.makemkv.com/download/makemkv-oss-${ver}.tar.gz";
    sha256 = "0415gw2nacb57sz5m0hcaznynmznc6v8qb6028qnsqgv39d4w8f8";
  };

  buildInputs = [openssl qt4 mesa zlib pkgconfig libav];

  libPath = stdenv.lib.makeLibraryPath [stdenv.cc.gcc openssl mesa qt4 zlib ] 
          + ":" + stdenv.cc.gcc + "/lib64";

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
