{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "dm-sans";
  version = "1.002";

  src = fetchzip {
    url = "https://github.com/googlefonts/dm-fonts/releases/download/v${finalAttrs.version}/DeepMindSans_v${finalAttrs.version}.zip";
    stripRoot = false;
    hash = "sha256-RSHHxiCac18qqF+hW5M3BbBcra4AQpNLLlUmhiWj9f8=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/truetype
    mv *.ttf $out/share/fonts/truetype

    runHook postInstall
  '';

  meta = {
    description = "Geometric sans-serif typeface";
    homepage = "https://github.com/googlefonts/dm-fonts";
    license = lib.licenses.ofl;
    maintainers = with lib.maintainers; [ gilice ];
  };
})
