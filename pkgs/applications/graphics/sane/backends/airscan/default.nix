{ lib, stdenv, fetchFromGitHub, pkg-config, avahi, libsoup, libjpeg
, sane-backends, meson, ninja }:
stdenv.mkDerivation rec {
  pname = "sane-airscan";
  version = "0.9.17";

  nativeBuildInputs = [ meson ninja pkg-config ];
  buildInputs = [ avahi libsoup libjpeg sane-backends ];

  src = fetchFromGitHub {
    owner = "alexpevzner";
    repo = pname;
    rev = version;
    sha256 = "03y0c1z5s3wbvxa9nvji62w42cmvcgm2sw72j7wm831995q3abmx";
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
