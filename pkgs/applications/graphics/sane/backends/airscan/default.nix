{ lib, stdenv, fetchFromGitHub, meson, ninja, pkg-config, avahi, libjpeg, libpng
, libxml2, gnutls, sane-backends }:
stdenv.mkDerivation rec {
  pname = "sane-airscan";
  version = "0.99.27";

  nativeBuildInputs = [ meson ninja pkg-config ];
  buildInputs = [ avahi gnutls libjpeg libpng libxml2 sane-backends ];

  src = fetchFromGitHub {
    owner = "alexpevzner";
    repo = pname;
    rev = version;
    sha256 = "sha256-29IPoLF4rmq8sGTi5RmpT1Fq8RJJlaepTt+2GWDU3es=";
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
