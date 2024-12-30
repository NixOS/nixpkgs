{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  avahi,
  libjpeg,
  libpng,
  libtiff,
  libxml2,
  gnutls,
  sane-backends,
}:
stdenv.mkDerivation rec {
  pname = "sane-airscan";
  version = "0.99.31";

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];
  buildInputs = [
    avahi
    gnutls
    libjpeg
    libpng
    libxml2
    libtiff
    sane-backends
  ];

  src = fetchFromGitHub {
    owner = "alexpevzner";
    repo = pname;
    rev = version;
    sha256 = "sha256-ZSmublTne8YZM8irowPedgEr2fzPzwt1QGWU+BBTAzA=";
  };

  meta = with lib; {
    homepage = "https://github.com/alexpevzner/sane-airscan";
    description = "Scanner Access Now Easy - Apple AirScan (eSCL) driver";
    mainProgram = "airscan-discover";
    longDescription = ''
      sane-airscan: Linux support of Apple AirScan (eSCL) compatible document scanners.
    '';
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ zaninime ];
  };
}
