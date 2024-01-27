{ stdenv
, lib
, fetchFromGitHub
, fetchpatch
, wrapQtAppsHook
, qmake
, pkg-config
, qtbase
, qtsvg
, qttools
, qtserialport
, qtwayland
, qt5compat
, boost
, libngspice
, libgit2
, quazip
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

stdenv.mkDerivation rec {
  pname = "fritzing";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = pname;
    repo = "fritzing-app";
    rev = "8f5f1373835050ce014299c78d91c24beea9b633";
    hash = "sha256-jLVNzSh2KwXpi3begtp/53sdBmQQbCnKMCm2p770etg=";
  };

  patches = [
    # Fix error caused by implicit call
    (fetchpatch {
      url = "https://aur.archlinux.org/cgit/aur.git/plain/0003-ParseResult-operator-bool-in-explicit.patch?h=fritzing&id=b2c79b55f0a2811e80bb1136b1e021fbc56937c9";
      hash = "sha256-9HdcNqLHEB0HQbF7AaTdUIJUbafwsRKPA+wfF4g8veU=";
    })
  ];

  nativeBuildInputs = [ qmake pkg-config qttools wrapQtAppsHook ];
  buildInputs = [
    qtbase
    qtsvg
    qtserialport
    qtwayland
    qt5compat
    boost
    libgit2
    quazip
    libngspice
  ];

  postPatch = ''
    # Use packaged quazip, libgit and ngspice
    sed -i "/pri\/quazipdetect.pri/d" phoenix.pro
    sed -i "/pri\/spicedetect.pri/d" phoenix.pro
    substituteInPlace phoenix.pro \
      --replace 'LIBGIT_STATIC = true' 'LIBGIT_STATIC = false'

    #TODO: Do not hardcode SHA.
    substituteInPlace src/fapplication.cpp \
      --replace 'PartsChecker::getSha(dir.absolutePath());' '"${partsSha}";'

    mkdir parts
    cp -a ${parts}/* parts/
  '';

  env.NIX_CFLAGS_COMPILE = lib.concatStringsSep " " [
    "-I${lib.getDev quazip}/include/QuaZip-Qt${lib.versions.major qtbase.version}-${quazip.version}/quazip"
    "-I${svgpp}/include"
  ];
  env.NIX_LDFLAGS = "-lquazip1-qt${lib.versions.major qtbase.version}";

  qmakeFlags = [
    "phoenix.pro"
  ];

  postFixup = ''
    # generate the parts.db file
    QT_QPA_PLATFORM=offscreen "$out/bin/Fritzing" \
      -db "$out/share/fritzing/parts/parts.db" \
      -pp "$out/share/fritzing/parts" \
      -folder "$out/share/fritzing"
  '';

  meta = with lib; {
    description = "An open source prototyping tool for Arduino-based projects";
    homepage = "https://fritzing.org/";
    license = with licenses; [ gpl3 cc-by-sa-30 ];
    maintainers = with maintainers; [ robberer muscaln ];
    platforms = platforms.linux;
    mainProgram = "Fritzing";
  };
}
