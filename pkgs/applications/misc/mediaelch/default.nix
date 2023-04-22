{ lib
, stdenv
, fetchFromGitHub
, fetchpatch

, cmake
, qttools
, wrapQtAppsHook

, curl
, ffmpeg
, libmediainfo
, libzen
, qt5compat ? null # qt6 only
, qtbase
, qtdeclarative
, qtmultimedia
, qtsvg
, qtwayland
, quazip
}:
let
  qtVersion = lib.versions.major qtbase.version;
in
stdenv.mkDerivation rec {
  pname = "mediaelch";
  version = "2.10.0";

  src = fetchFromGitHub {
    owner = "Komet";
    repo = "MediaElch";
    rev = "v${version}";
    sha256 = "sha256-hipOOG+ibfsJZKLcnB6a5+OOvSs4WUdpEY+RiVKJc+k=";
    fetchSubmodules = true;
  };

  patches = [
    # https://github.com/Komet/MediaElch/issues/1557
    # build: Fix build issue with Qt 6.5 on macOS (also other platforms)
    (fetchpatch {
      url = "https://github.com/Komet/MediaElch/commit/872b21decf95d70073400bedbe1ad183a8267791.patch";
      hash = "sha256-D1Ui5xg5cpvNX4IHfXQ7wN9I7Y3SuPFOWxWidcAlLEA=";
    })
  ];

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
    qtbase
    qtdeclarative
    qtmultimedia
    qtsvg
    qtwayland
    quazip
  ] ++ lib.optionals (qtVersion == "6") [
    qt5compat
  ];


  cmakeFlags = [
    "-DDISABLE_UPDATER=ON"
    "-DUSE_EXTERN_QUAZIP=ON"
    "-DMEDIAELCH_FORCE_QT${qtVersion}=ON"
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
