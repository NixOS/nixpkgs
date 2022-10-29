{ lib
, stdenv
, fetchFromGitHub

, cmake
, qttools
, wrapQtAppsHook

, curl
, ffmpeg
, libmediainfo
, libzen
, qt5compat
, qtbase
, qtdeclarative
, qtmultimedia
, qtsvg
, qtwayland
, quazip
}:

stdenv.mkDerivation rec {
  pname = "mediaelch";
  version = "2.8.18";

  src = fetchFromGitHub {
    owner = "Komet";
    repo = "MediaElch";
    rev = "v${version}";
    sha256 = "sha256-9kwU9j8YNF/OmzrQaRAlBpW+t/tIpZJw5+pfEoTmCBA=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    qttools
    wrapQtAppsHook
  ];

  buildInputs = [
    curl
    ffmpeg
    libmediainfo
    libzen
    qt5compat
    qtbase
    qtdeclarative
    qtmultimedia
    qtsvg
    qtwayland
    quazip
  ];


  cmakeFlags = [
    "-DDISABLE_UPDATER=ON"
    "-DUSE_EXTERN_QUAZIP=ON"
    "-DMEDIAELCH_FORCE_QT6=ON"
  ];

  # libmediainfo.so.0 is loaded dynamically
  qtWrapperArgs = [
    "--prefix LD_LIBRARY_PATH : ${libmediainfo}/lib"
  ];

  meta = with lib; {
    homepage = "https://mediaelch.de/mediaelch/";
    description = "Media Manager for Kodi";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ stunkymonkey ];
    platforms = platforms.linux;
  };
}
