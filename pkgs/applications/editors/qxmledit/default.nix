{
  lib,
  stdenv,
  fetchFromGitHub,
  qmake,
  qtbase,
  qtxmlpatterns,
  qtsvg,
  qtscxml,
  libGLU,
}:

stdenv.mkDerivation rec {
  pname = "qxmledit";
  version = "0.9.17";

  outputs = [
    "out"
    "doc"
  ];

  src = fetchFromGitHub {
    owner = "lbellonda";
    repo = pname;
    rev = version;
    hash = "sha256-UzN5U+aC/uKokSdeUG2zv8+mkaH4ndYZ0sfzkpQ3l1M=";
  };

  nativeBuildInputs = [ qmake ];

  buildInputs = [
    qtbase
    qtxmlpatterns
    qtsvg
    qtscxml
    libGLU
  ];

  qmakeFlags = [ "CONFIG+=release" ];

  preConfigure = ''
    export QXMLEDIT_INST_DATA_DIR="$out/share/data"
    export QXMLEDIT_INST_TRANSLATIONS_DIR="$out/share/i18n"
    export QXMLEDIT_INST_INCLUDE_DIR="$out/include"
    export QXMLEDIT_INST_DIR="$out/bin"
    export QXMLEDIT_INST_LIB_DIR="$out/lib"
    export QXMLEDIT_INST_DOC_DIR="$doc"
  '';

  dontWrapQtApps = true;

  meta = with lib; {
    broken = stdenv.hostPlatform.isDarwin;
    description = "Simple XML editor based on qt libraries";
    homepage = "https://sourceforge.net/projects/qxmledit";
    license = licenses.lgpl2;
    platforms = platforms.unix;
    changelog = "https://github.com/lbellonda/qxmledit/blob/${version}/NEWS";
    mainProgram = "qxmledit";
  };
}
