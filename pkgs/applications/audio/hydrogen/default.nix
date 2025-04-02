{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  wrapQtAppsHook,
  alsa-lib,
  ladspa-sdk,
  lash,
  libarchive,
  libjack2,
  liblo,
  libpulseaudio,
  libsndfile,
  lrdf,
  qtbase,
  qttools,
  qtxmlpatterns,
}:

stdenv.mkDerivation rec {
  pname = "hydrogen";
  version = "1.2.3";

  src = fetchFromGitHub {
    owner = "hydrogen-music";
    repo = pname;
    rev = version;
    sha256 = "sha256-7dgckFscyms+HW3xrsr3+lMua/H82U2jLkm/OKw3YWE=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapQtAppsHook
  ];
  buildInputs = [
    alsa-lib
    ladspa-sdk
    lash
    libarchive
    libjack2
    liblo
    libpulseaudio
    libsndfile
    lrdf
    qtbase
    qttools
    qtxmlpatterns
  ];

  cmakeFlags = [
    "-DWANT_DEBUG=OFF"
  ];

  meta = with lib; {
    description = "Advanced drum machine";
    homepage = "http://www.hydrogen-music.org";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ orivej ];
  };
}
