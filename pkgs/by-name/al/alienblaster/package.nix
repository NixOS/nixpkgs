{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  SDL,
  SDL_mixer,
  makeWrapper,
  xorg,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "alienblaster";
  version = "1.1.0";

  src = fetchurl {
    url = "http://www.schwardtnet.de/alienblaster/archives/alienblaster-${finalAttrs.version}.tgz";
    hash = "sha256-xAgVSMBazdkt9NchxVb28sGKYOK/XFE8sYaQrZ12mYA=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
    makeWrapper
    xorg.makedepend
  ];

  buildInputs = [
    SDL
    SDL_mixer
  ];

  makeFlags = [
    "-C"
    "src"
    "COMPILER=${stdenv.cc.targetPrefix}c++"
    "OPTIMIZATION="
  ];

  preBuild = ''
    makeFlagsArray+=(
      "SDL_FLAGS=$($PKG_CONFIG --cflags sdl) -I${SDL_mixer.dev}/include/SDL"
      "SDL_LIBS=$($PKG_CONFIG --libs sdl) -lSDL_mixer"
    )
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 alienBlaster "$out/libexec/alienblaster/alienblaster"
    install -d "$out/share/alienblaster"
    cp -a cfg images sound "$out/share/alienblaster/"

    makeWrapper "$out/libexec/alienblaster/alienblaster" "$out/bin/alienblaster" \
      --chdir "$out/share/alienblaster"

    install -Dm644 AUTHORS CHANGELOG README VERSION -t "$out/share/doc/alienblaster"

    runHook postInstall
  '';

  meta = {
    description = "2D space shooter game using SDL";
    homepage = "http://www.schwardtnet.de/alienblaster/";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ Zaczero ];
    mainProgram = "alienblaster";
    platforms = lib.platforms.unix;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
  };
})
