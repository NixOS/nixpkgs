{ lib
, stdenv
, fetchFromGitHub
, substituteAll
, wrapQtAppsHook
, qmake
, qtsvg
, qtx11extras
, graphviz
}:

stdenv.mkDerivation rec {
  pname = "qvge";
  version = "0.6.3";

  src = fetchFromGitHub {
    owner = "ArsMasiuk";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-rtbUAp3l0VZsu+D9HCHM3q0UkDLflw50rYRq/LP4Wu4=";
  };

  sourceRoot = "${src.name}/src";

  patches = (substituteAll {
    src = ./set-graphviz-path.patch;
    inherit graphviz;
  });

  nativeBuildInputs = [ wrapQtAppsHook qmake ];

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
