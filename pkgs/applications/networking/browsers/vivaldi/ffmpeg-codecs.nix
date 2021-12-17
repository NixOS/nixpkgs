{ lib, stdenv, fetchurl
, dpkg
}:

stdenv.mkDerivation rec {
  pname = "chromium-codecs-ffmpeg-extra";
  version = "94.0.4606.50";

  src = fetchurl {
    url = "https://launchpadlibrarian.net/558847674/${pname}_${version}-0ubuntu0.18.04.1_amd64.deb";
    sha256 = "sha256-H7Tzd8tkaoLClXtNiwEO5nD4+PPt7Jgs+gtLiag/KN4=";
  };

  buildInputs = [ dpkg ];

  unpackPhase = ''
    dpkg-deb -x $src .
    find .
  '';

  installPhase = ''
    install -vD usr/lib/chromium-browser/libffmpeg.so $out/lib/libffmpeg.so
  '';

  meta = with lib; {
    description = "Additional support for proprietary codecs for Vivaldi";
    homepage    = "https://ffmpeg.org/";
    license     = licenses.lgpl21;
    maintainers = with maintainers; [ betaboon lluchs ];
    platforms   = [ "x86_64-linux" ];
  };
}
