{
  lib,
  stdenv,
  fetchurl,
  libGLU,
  libGL,
  SDL,
  SDL_mixer,
  SDL_image,
  SDL_ttf,
  physfs,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "egoboo";
  version = "2.8.1";

  __structuredAttrs = true;

  src = fetchurl {
    url = "mirror://sourceforge/egoboo/egoboo-${finalAttrs.version}.tar.gz";
    hash = "sha256-omlBh9KKeq30yjubemxtzTuwPsjxRUNcdEu3evtfTCY=";
  };

  patches = [
    ./egoboo-fix-build.patch
    ./egoboo-fix-physfs.patch
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    ./egoboo-fix-darwin.patch
  ];

  strictDeps = true;

  nativeBuildInputs = [
    SDL
  ];

  buildInputs = [
    SDL
    SDL_mixer
    SDL_image
    SDL_ttf
    physfs
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libGLU
    libGL
  ];

  env = {
    NIX_CFLAGS_COMPILE = "-fcommon";
    NIX_LDFLAGS = lib.optionalString stdenv.hostPlatform.isLinux "-lm";
  };

  buildPhase = ''
    runHook preBuild
    make -C src PREFIX=$out
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 src/game/egoboo-2.x $out/bin/egoboo

    mkdir -p $out/share/egoboo
    cp -r controls.txt setup.txt basicdat modules \
      $out/share/egoboo/
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/Applications/Egoboo.app/Contents/{MacOS,Resources}

    install -Dm755 src/game/egoboo-2.x \
      $out/Applications/Egoboo.app/Contents/MacOS/egoboo

    install -Dm644 src/OSX/Info.plist \
      $out/Applications/Egoboo.app/Contents/Info.plist

    install -Dm644 src/OSX/skull.icns \
      $out/Applications/Egoboo.app/Contents/Resources/skull.icns
  ''
  + ''
    runHook postInstall
  '';

  meta = {
    description = "3D dungeon crawling adventure";
    homepage = "https://egoboo.sourceforge.net/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    mainProgram = "egoboo";
  };
})
