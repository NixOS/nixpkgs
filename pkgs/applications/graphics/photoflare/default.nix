{ mkDerivation, lib, stdenv, graphicsmagick, fetchFromGitHub, qmake, qtbase, qttools
}:

mkDerivation rec {
  pname = "photoflare";
  version = "1.6.6";

  src = fetchFromGitHub {
    owner = "PhotoFlare";
    repo = "photoflare";
    rev = "v${version}";
    sha256 = "07lrlxagv1bljj607s8m0zsbzx9jrvi18bnxahnm7r4i5car5x2d";
  };

  nativeBuildInputs = [ qmake qttools ];
  buildInputs = [ qtbase graphicsmagick ];

  qmakeFlags = [ "PREFIX=${placeholder "out"}" ];

  NIX_CFLAGS_COMPILE = "-I${graphicsmagick}/include/GraphicsMagick";

  enableParallelBuilding = true;

  meta = with lib; {
    description = "A cross-platform image editor with a powerful features and a very friendly graphical user interface";
    homepage = "https://photoflare.io";
    maintainers = [ maintainers.omgbebebe ];
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
