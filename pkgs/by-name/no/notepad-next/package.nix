{
  lib,
  fetchFromGitHub,
  qt5,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "notepad-next";
  version = "0.10";

  src = fetchFromGitHub {
    owner = "dail8859";
    repo = "NotepadNext";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DpqFu7Nt7l1rmQoJ7aQnFEGPxo8NDrowHxmyLdKIX4A=";
    # External dependencies - https://github.com/dail8859/NotepadNext/issues/135
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    qt5.qmake
    qt5.qttools
    qt5.wrapQtAppsHook
  ];
  buildInputs = [ qt5.qtx11extras ];

  qmakeFlags = [
    "PREFIX=${placeholder "out"}"
    "src/NotepadNext.pro"
  ];

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mv $out/bin $out/Applications
    rm -fr $out/share
    mkdir -p $out/bin
    ln -s $out/Applications/NotepadNext.app/Contents/MacOS/NotepadNext $out/bin/NotepadNext
  '';

  meta = with lib; {
    homepage = "https://github.com/dail8859/NotepadNext";
    description = "Cross-platform, reimplementation of Notepad++";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ sebtm ];
    broken = stdenv.hostPlatform.isAarch64;
    mainProgram = "NotepadNext";
  };
})
