{ mkDerivation
, lib
, fetchFromGitHub
, fetchpatch
, qmake
, pkg-config
, qtbase
, qtsvg
, qttools
, qtserialport
, boost
, libgit2
, quazip
}:

let
  # SHA256 of the fritzing-parts HEAD on the master branch,
  # which contains the latest stable parts definitions
  partsSha = "640fa25650211afccd369f960375ade8ec3e8653";

  parts = fetchFromGitHub {
    owner = "fritzing";
    repo = "fritzing-parts";
    rev = partsSha;
    sha256 = "sha256-4S65eX4LCnXCFQAOxmdvr8d0nAgTWcJooE2SpLYpcXI=";
  };
in

mkDerivation rec {
  pname = "fritzing";
  version = "unstable-2021-09-22";

  src = fetchFromGitHub {
    owner = pname;
    repo = "fritzing-app";
    rev = "f0af53a9077f7cdecef31d231b85d8307de415d4";
    sha256 = "sha256-fF38DrBoeZ0aKwVMNyYMPWa5rFPbIVXRARZT+eRat5Q=";
  };

  buildInputs = [ qtbase qtsvg qtserialport boost libgit2 quazip ];
  nativeBuildInputs = [ qmake pkg-config qttools ];

  patches = [
    # Add support for QuaZip 1.x
    (fetchpatch {
      url = "https://github.com/fritzing/fritzing-app/commit/ef83ebd9113266bb31b3604e3e9d0332bb48c999.patch";
      sha256 = "sha256-J43E6iBRIVbsuuo82gPk3Q7tyLhNkuuyYwtH8hUfcPU=";
    })
  ];

  postPatch = ''
    substituteInPlace phoenix.pro \
      --replace 'LIBGIT_STATIC = true' 'LIBGIT_STATIC = false'

    #TODO: Do not hardcode SHA.
    substituteInPlace src/fapplication.cpp \
      --replace 'PartsChecker::getSha(dir.absolutePath());' '"${partsSha}";'

    mkdir parts
    cp -a ${parts}/* parts/
  '';

  qmakeFlags = [
    "phoenix.pro"
    "DEFINES=QUAZIP_INSTALLED"
    "DEFINES+=QUAZIP_1X"
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
    maintainers = with maintainers; [ robberer musfay ];
    platforms = platforms.linux;
  };
}
