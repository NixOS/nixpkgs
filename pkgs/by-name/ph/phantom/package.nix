{
  stdenv,
  fetchFromGitea,
  qt6,
  cmark-gfm,
  cmake,
  ninja,
  lib
}:

stdenv.mkDerivation {
  pname = "phantom";
  version = "0-unstable-2025-12-22";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "ItsZariep";
    repo = "Phantom";
    rev = "7bba1e0a2d9b33d881fb999bb543324d14355505";
    hash = lib.fakeHash;
  };

  nativeBuildInputs = [
    qt6.wrapQtAppsHook
    cmake
    ninja
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtwebengine
    cmark-gfm
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp sqlauncher $out/bin

    runHook postInstall
  '';

  meta = with lib; {
    description = "Multi-tabbed Markdown editor with live preview";
    homepage = "https://codeberg.org/ItsZariep/Phantom";
    license = licenses.gpl3Only;
    mainProgram = "phantom";
    platforms = platforms.all;
    maintainers = with maintainers; [ reylak ];
  };
}
