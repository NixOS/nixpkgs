{
  stdenv,
  lib,
  fetchurl,
  SDL_compat,
  SDL_mixer,
  makeDesktopItem,
  copyDesktopItems,
  buildShareware ? false,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "rott";
  version = "1.1.2";

  src = fetchurl {
    url = "https://icculus.org/rott/releases/${finalAttrs.pname}-${finalAttrs.version}.tar.gz";
    hash = "sha256-ECUW6MMS9rC79sYj4fAcv7vDFKzorf4fIB1HsVvZJ/8=";
  };

  nativeBuildInputs = [ copyDesktopItems ];

  buildInputs = [
    SDL_compat
    SDL_mixer
  ];

  enableParallelBuilding = true;

  sourceRoot = "rott-${finalAttrs.version}/rott";

  makeFlags = [
    "SHAREWARE=${if buildShareware then "1" else "0"}"
  ];

  installPhase = ''
    runHook preInstall

    install -Dm755 -t $out/bin rott

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "rott";
      exec = "rott";
      desktopName = "Rise of the Triad: ${if buildShareware then "The HUNT Begins" else "Dark War"}";
      categories = [ "Game" ];
    })
  ];

  meta = {
    description = "SDL port of Rise of the Triad";
    mainProgram = "rott";
    homepage = "https://icculus.org/rott/";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ sander ];
    platforms = lib.platforms.all;
  };
})
