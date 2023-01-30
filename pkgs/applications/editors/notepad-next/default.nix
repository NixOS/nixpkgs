{ mkDerivation, lib, fetchFromGitHub, qmake, qttools, qtx11extras, stdenv }:

mkDerivation rec {
  pname = "notepad-next";
  version = "0.6";

  src = fetchFromGitHub {
    owner = "dail8859";
    repo = "NotepadNext";
    rev = "v${version}";
    sha256 = "sha256-t+TfyhQjUp4xJQ4vihAwm691dpt8ctQwLYDRRAQI7OM=";
    # External dependencies - https://github.com/dail8859/NotepadNext/issues/135
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ qmake qttools ];
  buildInputs = [ qtx11extras ];

  qmakeFlags = [
    "PREFIX=${placeholder "out"}"
    "src/NotepadNext.pro"
  ];

  postPatch = ''
    substituteInPlace src/i18n.pri \
      --replace 'EXTRA_TRANSLATIONS = \' "" \
      --replace '$$[QT_INSTALL_TRANSLATIONS]/qt_zh_CN.qm' ""
  '';

  meta = with lib; {
    homepage = "https://github.com/dail8859/NotepadNext";
    description = "Notepad++-like editor for the Linux desktop";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.sebtm ];
    broken = stdenv.isAarch64;
  };
}
