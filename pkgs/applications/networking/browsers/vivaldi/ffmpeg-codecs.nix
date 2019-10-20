{ stdenv, fetchurl
, dpkg
}:

stdenv.mkDerivation rec {
  name = "chromium-codecs-ffmpeg";
  version = "74.0.3729.169";

  src = fetchurl {
    url = "https://launchpadlibrarian.net/424938057/${name}-extra_${version}-0ubuntu0.16.04.1_amd64.deb";
    sha256 = "1ls2fshfk08hqsfvbd7p6rp2gv3n0xdy86rdh00wiz5qgl3skfzc";
  };

  buildInputs = [ dpkg ];

  unpackPhase = ''
    dpkg-deb -x $src .
    find .
  '';

  installPhase = ''
    install -vD usr/lib/chromium-browser/libffmpeg.so $out/lib/libffmpeg.so
  '';

  meta = with stdenv.lib; {
    description = "Additional support for proprietary codecs for Vivaldi";
    homepage    = "https://ffmpeg.org/";
    license     = licenses.lgpl21;
    maintainers = with maintainers; [ betaboon lluchs ];
    platforms   = [ "x86_64-linux" ];
  };
}
