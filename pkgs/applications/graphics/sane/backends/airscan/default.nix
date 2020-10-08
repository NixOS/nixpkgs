{ lib, stdenv, fetchFromGitHub, pkg-config, avahi, libsoup, libjpeg, libpng, gnutls
, sane-backends, meson, ninja }:
stdenv.mkDerivation rec {
  pname = "sane-airscan";
  version = "0.99.16";

  nativeBuildInputs = [ meson ninja pkg-config ];
  buildInputs = [ avahi libsoup libjpeg libpng gnutls sane-backends ];

  src = fetchFromGitHub {
    owner = "alexpevzner";
    repo = pname;
    rev = version;
    sha256 = "00lgcdbpns0shwlpkvrpfm4z05s7v5q3al4kcw6ii7xnkzmv1721";
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
