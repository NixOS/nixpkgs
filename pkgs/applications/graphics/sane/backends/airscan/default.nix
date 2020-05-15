{ lib, stdenv, fetchFromGitHub, pkg-config, avahi, libsoup, libjpeg, libpng
, sane-backends, meson, ninja }:
stdenv.mkDerivation rec {
  pname = "sane-airscan";
  version = "0.99.0";

  nativeBuildInputs = [ meson ninja pkg-config ];
  buildInputs = [ avahi libsoup libjpeg libpng sane-backends ];

  src = fetchFromGitHub {
    owner = "alexpevzner";
    repo = pname;
    rev = version;
    sha256 = "0bbw3s95v5fmkpmmd26v9cf1c40dm85bgxlhs06ski5my803ck0a";
  };

  meta = with lib; {
    homepage = "https://github.com/alexpevzner/sane-airscan";
    description = "Scanner Access Now Easy - Apple AirScan (eSCL) driver";
    longDescription = ''
      sane-airscan: Linux support of Apple AirScan (eSCL) compatible document scanners.
    '';
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ zaninime ];
  };
}
