{
  lib,
  stdenv,
  fetchzip,
  SDL,
  SDL_mixer,
  makeWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "abe";
  version = "1.1";

  src = fetchzip {
    url = "mirror://sourceforge/abe/abe/abe-${finalAttrs.version}/abe-${finalAttrs.version}.tar.gz";
    hash = "sha256-Kx1DleV5tj0rzAxyHtY4dLSVY6KwUPJpD1MwV1rBp+0=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    makeWrapper
    SDL
  ];
  buildInputs = [
    SDL
    SDL_mixer
  ];

  NIX_CFLAGS_COMPILE = [ "-std=gnu89" ];

  hardeningDisable = [ "format" ];

  # Needs SDL init even for --help, so force dummy drivers for a non-interactive test.
  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;
  checkPhase = ''
    runHook preCheck

    SDL_VIDEODRIVER=dummy SDL_AUDIODRIVER=dummy HOME=$(mktemp -d) ./src/abe --help \
      | grep -Fq "Show this help message."

    runHook postCheck
  '';

  postInstall = ''
    install -d "$out/share/abe"
    cp -a images maps sounds "$out/share/abe/"

    install -Dm644 README AUTHORS ChangeLog NEWS -t "$out/share/doc/abe"

    install -d "$out/libexec"
    mv "$out/bin/abe" "$out/libexec/abe"

    makeWrapper "$out/libexec/abe" "$out/bin/abe" \
      --chdir "$out/share/abe"
  '';

  meta = {
    description = "Side-scrolling platform game written using SDL";
    homepage = "https://abe.sourceforge.net/";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ Zaczero ];
    mainProgram = "abe";
    platforms = lib.platforms.unix;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
  };
})
