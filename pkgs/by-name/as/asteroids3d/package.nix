{ autoconf
, automake
, fetchgit
, freeglut
, lib
, libGL
, libGLU
, makeBinaryWrapper
, pkg-config
, stdenv
}:

stdenv.mkDerivation rec {
  pname = "asteroids3d";
  version = "1.0";
  src = fetchgit {
    url = "https://codeberg.org/jengelh/asteroids3D.git";
    rev = "v${version}";
    hash = "sha256-Pwb6RXgXpp/nkh9sRY5hJLpJch2KITaq8wRFpr2Lzw4=";
  };

  buildInputs = [
    freeglut
    libGL
    libGLU
  ];

  nativeBuildInputs = [
    autoconf
    automake
    makeBinaryWrapper
    pkg-config
  ];

  configurePhase = ''
    runHook preConfigure

    bash autogen.sh
    ./configure --prefix=$out --with-gamesdir=$out/share/${pname}/ --with-gamedatadir=$out/share/${pname}/${pname}-data/

    runHook postConfigure
  '';

  postInstall = ''
    makeBinaryWrapper $out/share/${pname}/asteroids3D $out/bin/${pname}
  '';

  meta = with lib; {
    homepage = "https://inai.de/projects/asteroids3D/";
    description = "A first person game of blowing up asteroids";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ raspher ];
  };
}
