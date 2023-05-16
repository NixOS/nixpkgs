{ mkDerivation, lib, fetchFromGitHub, qmake, qttools, qtx11extras, stdenv }:

mkDerivation rec {
  pname = "notepad-next";
<<<<<<< HEAD
  version = "0.6.3";
=======
  version = "0.6.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "dail8859";
    repo = "NotepadNext";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-1ci1g+qBDsw9IkqjI3tRvMsLBvnPU+nn7heYuid/e5M=";
=======
    sha256 = "sha256-4OjthXAzcAVwDA7+oK7sKiOiB7i/cYIdxyrz+9wPvDg=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

<<<<<<< HEAD
  postInstall = lib.optionalString stdenv.isDarwin ''
    mv $out/bin $out/Applications
    rm -fr $out/share
  '';

  meta = with lib; {
    homepage = "https://github.com/dail8859/NotepadNext";
    description = "A cross-platform, reimplementation of Notepad++";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
=======
  meta = with lib; {
    homepage = "https://github.com/dail8859/NotepadNext";
    description = "Notepad++-like editor for the Linux desktop";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    maintainers = [ maintainers.sebtm ];
    broken = stdenv.isAarch64;
  };
}
