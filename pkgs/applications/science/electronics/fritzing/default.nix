{
  stdenv,
  lib,
  fetchFromGitHub,
  wrapQtAppsHook,
  qmake,
  pkg-config,
  qtbase,
  qtsvg,
  qttools,
  qtserialport,
  qtwayland,
  qt5compat,
  boost,
  libngspice,
  libgit2,
  quazip,
  clipper,
}:

let
  # SHA256 of the fritzing-parts HEAD on the master branch,
  # which contains the latest stable parts definitions
  partsSha = "015626e6cafb1fc7831c2e536d97ca2275a83d32";

  parts = fetchFromGitHub {
    owner = "fritzing";
    repo = "fritzing-parts";
    rev = partsSha;
    hash = "sha256-5jw56cqxpT/8bf1q551WG53J6Lw5pH0HEtRUoNNMc+A=";
  };

  # Header-only library
  svgpp = fetchFromGitHub {
    owner = "svgpp";
    repo = "svgpp";
    rev = "v1.3.0";
    hash = "sha256-kJEVnMYnDF7bThDB60bGXalYgpn9c5/JCZkRSK5GoE4=";
  };
in

stdenv.mkDerivation {
  pname = "fritzing";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "fritzing";
    repo = "fritzing-app";
    rev = "dbdbe34c843677df721c7b3fc3e32c0f737e7e95";
    hash = "sha256-Xi5sPU2RGkqh7T+EOvwxJJKKYDhJfccyEZ8LBBTb2s4=";
  };

  nativeBuildInputs = [
    qmake
    pkg-config
    qttools
    wrapQtAppsHook
  ];
  buildInputs =
    [
      qtbase
      qtsvg
      qtserialport
      qt5compat
      boost
      libgit2
      quazip
      libngspice
      clipper
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      qtwayland
    ];

  postPatch = ''
    # Use packaged quazip, libgit and ngspice
    sed -i "/pri\/quazipdetect.pri/d" phoenix.pro
    sed -i "/pri\/spicedetect.pri/d" phoenix.pro
    substituteInPlace pri/libgit2detect.pri \
      --replace-fail 'LIBGIT_STATIC = true' 'LIBGIT_STATIC = false'

    #TODO: Do not hardcode SHA.
    substituteInPlace src/fapplication.cpp \
      --replace-fail 'PartsChecker::getSha(dir.absolutePath());' '"${partsSha}";'

    substituteInPlace phoenix.pro \
      --replace-fail "6.5.10" "${qtbase.version}"

    mkdir parts
    cp -a ${parts}/* parts/
  '';

  env.NIX_CFLAGS_COMPILE = lib.concatStringsSep " " [
    "-I${lib.getDev quazip}/include/QuaZip-Qt${lib.versions.major qtbase.version}-${quazip.version}"
    "-I${svgpp}/include"
    "-I${clipper}/include/polyclipping"
  ];
  env.NIX_LDFLAGS = "-lquazip1-qt${lib.versions.major qtbase.version}";

  qmakeFlags = [
    "phoenix.pro"
  ];

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir $out/Applications
    mv $out/bin/Fritzing.app $out/Applications/Fritzing.app
    cp FritzingInfo.plist $out/Applications/Fritzing.app/Contents/Info.plist
    makeWrapper $out/Applications/Fritzing.app/Contents/MacOS/Fritzing $out/bin/Fritzing
  '';

  postFixup = ''
    # generate the parts.db file
    QT_QPA_PLATFORM=offscreen "$out/bin/Fritzing" \
      -db "$out/share/fritzing/parts/parts.db" \
      -pp "$out/share/fritzing/parts" \
      -folder "$out/share/fritzing"
  '';

  meta = with lib; {
    description = "Open source prototyping tool for Arduino-based projects";
    homepage = "https://fritzing.org/";
    license = with licenses; [
      gpl3
      cc-by-sa-30
    ];
    maintainers = with maintainers; [
      robberer
      muscaln
    ];
    platforms = platforms.unix;
    mainProgram = "Fritzing";
  };
}
