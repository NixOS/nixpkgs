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
  partsSha = "76235099ed556e52003de63522fdd74e61d53a36";

  parts = fetchFromGitHub {
    owner = "fritzing";
    repo = "fritzing-parts";
    rev = partsSha;
    hash = "sha256-1QVcPbRBOSYnNFsp7B2OyPXYuPaINRv9yEqGZFd662Y=";
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
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "fritzing";
    repo = "fritzing-app";
    rev = "a8c6ef7cf66f7a42b9b233d6137f1b70a9573a25";
    hash = "sha256-a/bWAUeDPj3g8BECOlXuqyCi4JgGLLs1605m380Drt0=";
  };

  patches = [
    # Fix build with Qt >= 6.9
    ./fix-stricter-types.patch
  ];

  nativeBuildInputs = [
    qmake
    pkg-config
    qttools
    wrapQtAppsHook
  ];

  buildInputs = [
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

    substituteInPlace src/simulation/ngspice_simulator.cpp \
      --replace-fail 'path + "/" + libName' '"${libngspice}/lib/libngspice.so"'

    mkdir parts
    cp -a ${parts}/* parts/
  '';

  env = {
    NIX_CFLAGS_COMPILE = lib.concatStringsSep " " [
      "-I${lib.getDev quazip}/include/QuaZip-Qt${lib.versions.major qtbase.version}-${quazip.version}"
      "-I${svgpp}/include"
      "-I${clipper}/include/polyclipping"
    ];
    NIX_LDFLAGS = "-lquazip1-qt${lib.versions.major qtbase.version}";
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
