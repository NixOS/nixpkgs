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
  version = "2.2.1";

  src = fetchFromGitHub {
    owner = "nuttyartist";
    repo = "notes";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ShChF87ysRoisKshY86kJTa3ZAiQhBOImuL8OsEqgBo=";
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

  postInstall = lib.optionalString stdenv.isDarwin ''
    mkdir $out/Applications
    mv $out/bin/Notes.app $out/Applications
  '';

  meta = {
    description = "A fast and beautiful note-taking app";
    mainProgram = "notes";
    downloadPage = "https://github.com/nuttyartist/notes";
    homepage = "https://www.get-notes.com";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ zendo ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
