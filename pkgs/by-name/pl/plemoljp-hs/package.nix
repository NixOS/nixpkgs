{
  stdenvNoCC,
  fetchzip,
  plemoljp,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "plemoljp-hs";

  # plemoljp's updateScript also updates this version.
  # nixpkgs-update: no auto update
  inherit (plemoljp) version;

  src = fetchzip {
    url = "https://github.com/yuru7/PlemolJP/releases/download/v${finalAttrs.version}/PlemolJP_HS_v${finalAttrs.version}.zip";
    hash = "sha256-V21T8ktNZE4nq3SH6aN9iIJHmGTkZuMsvT84yHbwSqI=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm444 PlemolJP_HS/*.ttf -t $out/share/fonts/truetype/plemoljp-hs
    install -Dm444 PlemolJP35_HS/*.ttf -t $out/share/fonts/truetype/plemoljp-hs-35
    install -Dm444 PlemolJPConsole_HS/*.ttf -t $out/share/fonts/truetype/plemoljp-hs-console
    install -Dm444 PlemolJP35Console_HS/*.ttf -t $out/share/fonts/truetype/plemoljp-hs-35console

    runHook postInstall
  '';

  meta = plemoljp.meta // {
    description = "Composite font of IBM Plex Mono, IBM Plex Sans JP and hidden full-width space";
  };
})
