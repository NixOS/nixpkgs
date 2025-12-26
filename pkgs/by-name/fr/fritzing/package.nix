{
  stdenv,
  lib,
  fetchFromGitHub,
  kdePackages,
  pkg-config,
  qt6,
  boost,
  libngspice,
  libgit2,
  clipper,
}:

let
  # SHA256 of the fritzing-parts HEAD on the develop branch,
  # which contains the latest stable parts definitions
  partsSha = "73bc0559bb8399b2f895d68f032e41d7efc720c0";

  parts = fetchFromGitHub {
    owner = "fritzing";
    repo = "fritzing-parts";
    rev = partsSha;
    hash = "sha256-2aXvSXWjQliEChQGhcCicOVoAqeNdeq69wQVYQsd2ew=";
  };

  # Header-only library
  svgpp = fetchFromGitHub {
    owner = "svgpp";
    repo = "svgpp";
    tag = "v1.3.1";
    hash = "sha256-nW0ns06XWfUi22nOKZzFKgAOHVIlQqChW8HxUDOFMh4=";
  };
in

stdenv.mkDerivation {
  pname = "fritzing";
  version = "1.0.6";

  src = fetchFromGitHub {
    owner = "fritzing";
    repo = "fritzing-app";
    rev = "04e5bb0241e8f1de24d0fce9be070041c6d5b68e";
    hash = "sha256-JlqBdzWscJoD859KMYgT/af41WNWThP65K3zh2PC2jM=";
  };

  patches = [
    # Fix build with Qt >= 6.9
    ./fix-stricter-types.patch
  ];

  nativeBuildInputs = [
    kdePackages.qmake
    pkg-config
    qt6.qttools
    kdePackages.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtsvg
    qt6.qtserialport
    kdePackages.qt5compat
    boost
    libgit2
    kdePackages.quazip
    libngspice
    clipper
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    qt6.qtwayland
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
      --replace-fail "6.5.10" "${qt6.qtbase.version}"

    substituteInPlace src/simulation/ngspice_simulator.cpp \
      --replace-fail 'path + "/" + libName' '"${libngspice}/lib/libngspice.so"'

    mkdir parts
    cp -a ${parts}/* parts/
  '';

  env = {
    NIX_CFLAGS_COMPILE = lib.concatStringsSep " " (
      [
        "-I${lib.getDev kdePackages.quazip}/include/QuaZip-Qt${lib.versions.major qt6.qtbase.version}-${kdePackages.quazip.version}"
        "-I${svgpp}/include"
        "-I${clipper}/include/polyclipping"
      ]
      ++ lib.optionals stdenv.hostPlatform.isDarwin [ "-F${kdePackages.qt5compat}/lib" ]
    );
    NIX_LDFLAGS = "-lquazip1-qt${lib.versions.major qt6.qtbase.version}";
  };

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

  meta = {
    description = "Open source prototyping tool for Arduino-based projects";
    homepage = "https://fritzing.org";
    license = with lib.licenses; [
      gpl3
      cc-by-sa-30
    ];
    maintainers = with lib.maintainers; [
      robberer
      muscaln
    ];
    platforms = lib.platforms.unix;
    mainProgram = "Fritzing";
  };
}
