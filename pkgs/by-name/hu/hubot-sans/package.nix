{
  lib,
  fetchzip,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "hubot-sans";
  version = "1.0.1";

  src = fetchzip {
    url = "https://github.com/github/hubot-sans/releases/download/v${finalAttrs.version}/Hubot-Sans.zip";
    hash = "sha256-EWTyoGNqyZcqlF1H1Tdcodc8muHIo8C9gbSPAjiogRk=";
    stripRoot = false;
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 Hubot\ Sans/TTF/*.ttf -t $out/share/fonts/truetype/
    install -Dm644 Hubot\ Sans/OTF/*.otf -t $out/share/fonts/opentype/

    runHook postInstall
  '';

  meta = {
    description = "Variable font from GitHub";
    homepage = "https://github.com/github/hubot-sans";
    changelog = "https://github.com/github/hubot-sans/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.ofl;
    longDescription = ''
      Hubot Sans is Mona Sans’s robotic sidekick. The typeface is designed with
      more geometric accents to lend a technical and idiosyncratic feel—perfect
      for headers and pull-quotes. Made together with Degarism.

      Hubot Sans is a variable font. Variable fonts enable different variations
      of a typeface to be incorporated into one single file, and are supported
      by all major browsers.
    '';
    maintainers = with lib.maintainers; [ drupol ];
    platforms = lib.platforms.all;
  };
})
