{
  lib,
  stdenv,
  fetchFromGitHub,
  ncurses,
}:

stdenv.mkDerivation rec {
  pname = "ninvaders";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "TheZ3ro";
    repo = "ninvaders";
    rev = "c6ab411";  # Pinned to the latest commit
    sha256 = "091n36vp0c43jgmdfigx24yjk2w67myb89h2zkh26z75f1y6lr41";
  };

  # sourceRoot = "ninvaders-master";

  postUnpack = ''
    echo "Source directory:"
    ls -la
  '';

  buildInputs = [ ncurses ];

  patchPhase = ''
    sed -i 's/^int /extern int /' aliens.h ufo.h # Adjust paths as needed
    echo "Added extern to global variables"

    # Define global variables in their corresponding source files
    echo "int alienshotx[10], alienshoty[10], alienshotnum, lowest_ship[10], bunker[4][81];" >> aliens.c
    echo "int alienBlock[5][10], shipnum;" >> aliens.c
    echo "int skill_level, level, weite;" >> nInvaders.c
    #echo "int ufo;" >> ufo.c
    echo "Ufo ufo;" >> ufo.c
    echo "HighScore highscore;" >> highscore.c

    # Fix array bounds in aliens.c
    sed -i 's/for (k=0;k<11;k++)/for (k=0;k<10;k++)/' aliens.c
  '';

  # Explicitly define the build phase to handle `Makefile` placeholders
  #configurePhase = ''
  # if [-f MakeFile ]; then
  #  substituteInPlace Makefile \
  #   --subst-var CC --subst-var-by ${stdenv.cc} \
  #  --subst-var CFLAGS --subst-var-by "-I${ncurses.dev}/include" \
  # --subst-var LIBS --subst-var-by "-L${ncurses.out}/lib -lncurses";
  #fi
  #'';

  configurePhase = ''
    chmod +x ./configure
    ./configure --prefix=$out \

      CC=${stdenv.cc} \
      CFLAGS="-I${ncurses.dev}/include" \
      LDFLAGS="-L${ncurses.out}/lib -lncurses"
  '';

  buildPhase = ''
    make CFLAGS="-g -O2 -fcommon -Wno-stringop-overflow -Wno-unused-result"
  '';

  installPhase = ''
    #mkdir -p $out/bin
    #cp nInvaders $out/bin/
    runHook preInstall
    install -Dm755 nInvaders -t $out/bin
    runHook postInstall
  '';

  meta = with lib; {
    description = "A Space Invaders Clone based on ncurses";
    homepage = "https://github.com/TheZ3ro/ninvaders";
    license = licenses.gpl2;
    maintainers = with maintainers; [ zutesuit ];
  };
}
