{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "departure-mono";
  version = "1.350";

  src = fetchzip {
    url = "https://github.com/rektdeckard/departure-mono/releases/download/v${finalAttrs.version}/DepartureMono-${finalAttrs.version}.zip";
    stripRoot = false;
    hash = "sha256-MMmS1yjhy50fgMK5h0526YKRfQJuOcEAHqxn9rhUwCc=";
  };

  installPhase = ''
    runHook preInstall

    install -D -m 444 *.otf -t $out/share/fonts/otf
    install -D -m 444 *.woff -t $out/share/fonts/woff
    install -D -m 444 *.woff2 -t $out/share/fonts/woff2

    runHook postInstall
  '';

  meta = {
    changelog = "https://github.com/rektdeckard/departure-mono/releases/tag/v${finalAttrs.version}";
    description = "Departure Mono is a monospaced pixel font with a lo-fi technical vibe";
    homepage = "https://departuremono.com/";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ drupol ];
  };
})
