{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchDebianPatch,
  cmake,
  pkg-config,
  fluidsynth,
  fmt,
  freetype,
  libjpeg,
  libopenmpt,
  libpng,
  libsndfile,
  libvorbis,
  mpg123,
  qt6,
}:

stdenv.mkDerivation rec {
  pname = "gargoyle";
  version = "2023.1";

  src = fetchFromGitHub {
    owner = "garglk";
    repo = "garglk";
    tag = version;
    hash = "sha256-XsN5FXWJb3DSOjipxr/HW9R7QS+7iEaITERTrbGEMwA=";
  };

  patches = [
    (fetchDebianPatch {
      pname = "gargoyle-free";
      version = "2023.1+dfsg";
      debianRevision = "4";
      patch = "ftbfs_gcc14.patch";
      hash = "sha256-eMx/RlUpq5Ez+1L8VZo40Y3h2ZKkqiQEmKTlkZRMXnI=";
    })
  ];

  postPatch = ''
    substituteInPlace garglk/garglk.pc.in \
      --replace "\''${prefix}/@CMAKE_INSTALL_LIBDIR@" "@CMAKE_INSTALL_FULL_LIBDIR@" \
      --replace "\''${prefix}/@CMAKE_INSTALL_INCLUDEDIR@" "@CMAKE_INSTALL_FULL_INCLUDEDIR@"
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    fluidsynth
    fmt
    freetype
    libjpeg
    libopenmpt
    libpng
    libsndfile
    libvorbis
    mpg123
    qt6.qtbase
    qt6.qtmultimedia
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
    qt6.qtwayland
  ];

  cmakeFlags = [
    (lib.cmakeFeature "INTERFACE" "QT")
    (lib.cmakeFeature "SOUND" "QT")
    (lib.cmakeBool "WITH_QT6" true)
    # fatal error: 'macglk_startup.h' file not found
    (lib.cmakeBool "WITH_AGILITY" (!stdenv.hostPlatform.isDarwin))
    (lib.cmakeBool "WITH_LEVEL9" (!stdenv.hostPlatform.isDarwin))
    (lib.cmakeBool "WITH_MAGNETIC" (!stdenv.hostPlatform.isDarwin))
  ];

  meta = with lib; {
    homepage = "http://ccxvii.net/gargoyle/";
    license = licenses.gpl2Plus;
    description = "Interactive fiction interpreter GUI";
    mainProgram = "gargoyle";
    platforms = platforms.unix;
    maintainers = with maintainers; [ orivej ];
  };
}
