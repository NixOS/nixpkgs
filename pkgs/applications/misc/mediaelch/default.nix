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
  version = "2.10.2";

  src = fetchFromGitHub {
    owner = "Komet";
    repo = "MediaElch";
    rev = "v${version}";
    sha256 = "sha256-y8NXBPShmhp0QiuSbVA2JvZrv70Z76Kmdw+RuBnMtPY=";
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
