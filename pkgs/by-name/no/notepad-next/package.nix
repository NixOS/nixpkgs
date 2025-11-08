{
  lib,
  fetchFromGitHub,
  qt5,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "notepad-next";
  version = "0.12";

  src = fetchFromGitHub {
    owner = "dail8859";
    repo = "NotepadNext";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YD4tIPh5iJpbcDMZk334k2AV9jTVWCSGP34Mj2x0cJ0=";
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

  meta = {
    homepage = "https://github.com/dail8859/NotepadNext";
    description = "Cross-platform, reimplementation of Notepad++";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ sebtm ];
    broken = stdenv.hostPlatform.isAarch64;
    mainProgram = "NotepadNext";
  };
})
