{ mkDerivation, lib, fetchFromGitHub, qmake, qttools, qtx11extras, stdenv }:

mkDerivation rec {
  pname = "notepad-next";
  version = "0.6.3";

  src = fetchFromGitHub {
    owner = "dail8859";
    repo = "NotepadNext";
    rev = "v${version}";
    sha256 = "sha256-1ci1g+qBDsw9IkqjI3tRvMsLBvnPU+nn7heYuid/e5M=";
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

  postInstall = lib.optionalString stdenv.isDarwin ''
    mv $out/bin $out/Applications
    rm -fr $out/share
  '';

  meta = with lib; {
    homepage = "https://github.com/dail8859/NotepadNext";
    description = "A cross-platform, reimplementation of Notepad++";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = [ maintainers.sebtm ];
    broken = stdenv.isAarch64;
  };
}
