{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,

  cmake,
  qttools,
  wrapQtAppsHook,

  curl,
  ffmpeg,
  libmediainfo,
  libzen,
  qt5compat ? null, # qt6 only
  qtbase,
  qtdeclarative,
  qtmultimedia,
  qtsvg,
  qtwayland,
  quazip,
}:
let
  qtVersion = lib.versions.major qtbase.version;
in
stdenv.mkDerivation rec {
  pname = "mediaelch";
  version = "2.12.0";

  src = fetchFromGitHub {
    owner = "Komet";
    repo = "MediaElch";
    rev = "v${version}";
    hash = "sha256-m2d4lnyD8HhhqovMdeG36dMK+4kJA7rlPHE2tlhfevo=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    qttools
    wrapQtAppsHook
  ];

  buildInputs =
    [
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
    ]
    ++ lib.optionals (qtVersion == "6") [
      qt5compat
    ];

  patches = [
    # fix from: https://github.com/Komet/MediaElch/pull/1878
    (fetchpatch {
      url = "https://github.com/Komet/MediaElch/commit/dbea12fbf2c1fe603819392aa2a181cffa168548.patch";
      hash = "sha256-Lv6rvjKbRNr5XrdZhPyw4S4RRCOnfAGhWgcSLo0gqS8=";
    })
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
    mainProgram = "MediaElch";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ stunkymonkey ];
    platforms = platforms.linux;
  };
}
