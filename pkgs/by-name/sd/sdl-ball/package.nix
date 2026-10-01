{
  lib,
  stdenv,
  fetchFromGitHub,
  desktopToDarwinBundle,
  SDL2,
  SDL2_mixer,
  SDL2_ttf,
  SDL2_image,
  libGLU,
  wiiuse,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sdl-ball";
  version = "0-unstable-2022-10-20";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "DusteDdk";
    repo = "SDL-Ball";
    # Would use tag but it's 30 commits behind and the project isn't super up-to-date
    rev = "437701b3e1b10618f7f05461b904d482cd1b1e59";
    hash = "sha256-qFgE4VV4+RztVIUl/YXD81bIgyafsjyiQdkWRBjFKnA=";
  };

  nativeBuildInputs = lib.optional stdenv.hostPlatform.isDarwin desktopToDarwinBundle;

  buildInputs = [
    SDL2
    SDL2_mixer
    SDL2_ttf
    SDL2_image
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libGLU
    # Putting wiiuse behind linux because i got weird errors, probably doable though
    wiiuse
  ];

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail 'sdl-config --cflags' 'sdl2-config --cflags'
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace Makefile \
      --replace-fail '-lGL -lGLU' '-framework OpenGL'
    substituteInPlace main.cpp display.cpp \
      --replace-fail '<GL/gl.h>'  '<OpenGL/gl.h>'  \
      --replace-fail '<GL/glu.h>' '<OpenGL/glu.h>'
    substituteInPlace main.cpp \
      --replace-fail '<GL/glext.h>' '<OpenGL/glext.h>'
    substituteInPlace display.cpp \
      --replace-fail 'SDL_Rect displayBounds[numOfDisplays]={0};' 'SDL_Rect displayBounds[numOfDisplays];'
    substituteInPlace Makefile \
      --replace-fail 'CXXFLAGS+=' 'CXXFLAGS+= -DGL_SILENCE_DEPRECATION '
  '';

  env = lib.optionalAttrs stdenv.hostPlatform.isLinux {
    LIBS = "-lwiiuse";
    CXXFLAGS = "-DWITH_WIIUSE";
  };

  preBuild = ''
    makeFlagsArray+=(DATADIR="$out/share/sdl-ball/themes/")
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 sdl-ball $out/bin/sdl-ball

    install -d $out/share/sdl-ball/leveleditor
    cp -r themes $out/share/sdl-ball/
    cp README $out/share/sdl-ball/
    cp -r leveleditor/gfx leveleditor/index.html $out/share/sdl-ball/leveleditor/

    install -Dm644 themes/default/icon32.png $out/share/pixmaps/sdl-ball.png
    install -Dm644 sdl-ball.desktop $out/share/applications/sdl-ball.desktop

    runHook postInstall
  '';

  postFixup = lib.optionalString stdenv.hostPlatform.isDarwin ''
    # Making the symlink and the internall app bundle the same
    appBin=$out/Applications/SDL-Ball.app/Contents/MacOS/sdl-ball
    rm "$appBin"
    mv $out/bin/sdl-ball "$appBin"
    ln -s ../Applications/SDL-Ball.app/Contents/MacOS/sdl-ball $out/bin/sdl-ball
  '';

  meta = {
    description = "Breakout clone with pretty graphics";
    homepage = "http://sdl-ball.sourceforge.net/";
    changelog = "https://github.com/DusteDdk/SDL-Ball/blob/HEAD/changelog.txt";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ philocalyst ];
    platforms = lib.platforms.unix;
    mainProgram = "sdl-ball";
  };
})
