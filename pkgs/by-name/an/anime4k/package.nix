{
  fetchFromGitHub,
  lib,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "anime4k";
  version = "4.0.1";

  src = fetchFromGitHub {
    owner = "bloc97";
    repo = "Anime4k";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OQWJWcDpwmnJJ/kc4uEReaO74dYFlxNQwf33E5Oagb0=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 glsl/*/*.glsl -t $out

    runHook postInstall
  '';

  meta = {
    description = "High-quality real time upscaler for anime";
    homepage = "https://github.com/bloc97/Anime4K";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ surfaceflinger ];
    platforms = lib.platforms.all;
  };
})
