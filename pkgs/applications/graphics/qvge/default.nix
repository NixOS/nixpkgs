{
  lib,
  stdenv,
  fetchFromGitHub,
  replaceVars,
  wrapQtAppsHook,
  qmake,
  qtsvg,
  qtx11extras,
  graphviz,
}:

stdenv.mkDerivation rec {
  pname = "qvge";
  version = "0.6.3-unstable-2024-04-08";

  src = fetchFromGitHub {
    owner = "ArsMasiuk";
    repo = "qvge";
    #tag = "v${version}";
    rev = "5751948358d407673cfda10f52892683be143d42";
    hash = "sha256-Rh8ahS/9x2aWu4THjLKoog58+yJoCQ6GETaAQTW4Hq8=";
  };

  sourceRoot = "${src.name}/src";

  patches = (
    replaceVars ./set-graphviz-path.patch {
      inherit graphviz;
    }
  );

  nativeBuildInputs = [
    wrapQtAppsHook
    qmake
  ];

  buildInputs = if stdenv.hostPlatform.isDarwin then [ qtsvg ] else [ qtx11extras ];

  meta = with lib; {
    description = "Qt Visual Graph Editor";
    mainProgram = "qvgeapp";
    homepage = "https://github.com/ArsMasiuk/qvge";
    license = licenses.mit;
    maintainers = with maintainers; [ sikmir ];
    platforms = platforms.unix;
  };
}
