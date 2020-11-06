{ mkDerivation, stdenv, graphicsmagick, fetchFromGitHub, qmake, qtbase, qttools
}:

mkDerivation rec {
  pname = "photoflare";
  version = "1.6.5";

  src = fetchFromGitHub {
    owner = "PhotoFlare";
    repo = "photoflare";
    rev = "v${version}";
    sha256 = "0a394324h7ds567z3i3pw6kkii78n4qwdn129kgkkm996yh03q89";
  };

  nativeBuildInputs = [ qmake qttools ];
  buildInputs = [ qtbase graphicsmagick ];

  qmakeFlags = [ "PREFIX=${placeholder "out"}" ];

  NIX_CFLAGS_COMPILE = "-I${graphicsmagick}/include/GraphicsMagick";

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A cross-platform image editor with a powerful features and a very friendly graphical user interface";
    homepage = "https://photoflare.io";
    maintainers = [ maintainers.omgbebebe ];
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
