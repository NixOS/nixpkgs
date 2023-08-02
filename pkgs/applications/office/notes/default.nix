{ lib
, stdenv
, fetchFromGitHub
, cmake
, wrapQtAppsHook
, qtbase
, qtdeclarative
, Cocoa
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "notes";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "nuttyartist";
    repo = "notes";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ZfAm77UHyjs2aYOYb+AhKViz6uteb7+KKSedonSiMkY=";
    fetchSubmodules = true;
  };

  cmakeFlags = [ "-DUPDATE_CHECKER=OFF" ];

  nativeBuildInputs = [
    cmake
    wrapQtAppsHook
  ];

  buildInputs = [
    qtbase
    qtdeclarative
  ] ++ lib.optionals stdenv.isDarwin [
    Cocoa
  ];

  postInstall = lib.optionalString stdenv.isLinux ''
    # temporary fix: https://github.com/nuttyartist/notes/issues/613
    substituteInPlace $out/share/applications/io.github.nuttyartist.notes.desktop \
       --replace 'Exec=notes' 'Exec=env QT_STYLE_OVERRIDE= notes'
  '' + lib.optionalString stdenv.isDarwin ''
    mkdir $out/Applications
    mv $out/bin/Notes.app $out/Applications
  '';

  meta = {
    description = "A fast and beautiful note-taking app";
    downloadPage = "https://github.com/nuttyartist/notes";
    homepage = "https://www.get-notes.com";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ zendo ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
