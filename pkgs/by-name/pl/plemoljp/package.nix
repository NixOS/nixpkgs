{
  lib,
  stdenvNoCC,
  fetchzip,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "plemoljp";
  version = "3.0.0";

  src = fetchzip {
    url = "https://github.com/yuru7/PlemolJP/releases/download/v${finalAttrs.version}/PlemolJP_v${finalAttrs.version}.zip";
    hash = "sha256-R4zC1pnM72FVqBQ5d03z8vyVccsM163BE15m2hdEnSA=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm444 PlemolJP/*.ttf -t $out/share/fonts/truetype/plemoljp
    install -Dm444 PlemolJP35/*.ttf -t $out/share/fonts/truetype/plemoljp-35
    install -Dm444 PlemolJPConsole/*.ttf -t $out/share/fonts/truetype/plemoljp-console
    install -Dm444 PlemolJP35Console/*.ttf -t $out/share/fonts/truetype/plemoljp-35console

    runHook postInstall
  '';

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [ "--version-regex=^v([0-9.]+)$" ];
    };
  };

  meta = {
    description = "Composite font of IBM Plex Mono and IBM Plex Sans JP";
    homepage = "https://github.com/yuru7/PlemolJP";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ kachick ];
  };
})
