{ stdenv, fetchurl
, dpkg
}:

stdenv.mkDerivation rec {
  name = "chromium-codecs-ffmpeg";
  version = "78.0.3904.70";

  src = fetchurl {
    url = "https://launchpadlibrarian.net/449403909/${name}-extra_${version}-0ubuntu0.16.04.2_amd64.deb";
    sha256 = "00j604nm49z6hbyw7xsxcvmdjf7117kb478plkpizzvmm3w72b9v";
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
