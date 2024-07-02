{ lib
, stdenv
, fetchFromGitHub
, qt5
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "skyscraper";
  version = "3.11.1";

  src = fetchFromGitHub {
    owner = "Gemba";
    repo = "skyscraper";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-tGKztGkDG6nmq4aoOkQ4XVOcnL1NdZJ0zNUe0lUPlZ4=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    qt5.wrapQtAppsHook
    qt5.qmake
  ];

  env.PREFIX = placeholder "out";

  meta = {
    description = "Powerful and versatile game data scraper written in Qt and C++";
    homepage = "https://gemba.github.io/skyscraper/";
    downloadPage = "https://github.com/Gemba/skyscraper/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ ashgoldofficial ];
    mainProgram = "Skyscraper";
    platforms = lib.platforms.linux;
  };
})
