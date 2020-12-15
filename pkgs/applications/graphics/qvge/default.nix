{ lib
, mkDerivation
, fetchFromGitHub
, substituteAll
, qmake
, qtx11extras
, graphviz
}:

mkDerivation rec {
  pname = "qvge";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "ArsMasiuk";
    repo = pname;
    rev = "v${version}";
    sha256 = "0qy73dngl1xm6mr2306ddzbbrzk6yszp3y15phs861bfxynzkqjz";
  };

  prePatch = "cd src";

  patches = (substituteAll {
    src = ./set-graphviz-path.patch;
    inherit graphviz;
  });

  nativeBuildInputs = [ qmake ];

  buildInputs = [ qtx11extras ];

  meta = with lib; {
    description = "Qt Visual Graph Editor";
    homepage = "https://github.com/ArsMasiuk/qvge";
    license = licenses.mit;
    maintainers = with maintainers; [ sikmir ];
    platforms = with platforms; linux;
  };
}
