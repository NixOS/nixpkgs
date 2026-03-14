{
  lib,
  stdenv,
  fetchurl,
  ncurses,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "alienwave";
  version = "0.4.0";

  src = fetchurl {
    url = "https://www.alessandropira.org/alienwave/alienwave-${finalAttrs.version}.tar.gz";
    hash = "sha256-nzF8+g+r+Y5cR9x5P26028oLbmXhNuBmGrwmfOcg/EQ=";
  };

  strictDeps = true;

  buildInputs = [ ncurses ];

  buildPhase = ''
    runHook preBuild

    $CC $CPPFLAGS $CFLAGS \
      main.c blit.c aliens.c xzarna.c fire.c shield.c levels.c util.c \
      -o alienwave \
      $LDFLAGS -lncurses

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 alienwave -t "$out/bin"
    install -Dm644 README STORY -t "$out/share/doc/alienwave"

    runHook postInstall
  '';

  meta = {
    description = "Simple ncurses shoot-'em-up game";
    homepage = "https://www.alessandropira.org/alienwave/aw.html";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ Zaczero ];
    mainProgram = "alienwave";
    platforms = lib.platforms.unix;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
  };
})
