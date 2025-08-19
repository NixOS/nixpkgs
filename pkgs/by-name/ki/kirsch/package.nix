{
  lib,
  stdenvNoCC,
  fetchzip,
  xorg,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "kirsch";
  version = "0.6.1";

  src = fetchzip {
    url = "https://github.com/molarmanful/kirsch/releases/download/v${finalAttrs.version}/kirsch-release_v${finalAttrs.version}.zip";
    hash = "sha256-6POi3N1JX6FFWHwqOlB3mrkHMYG+TJXz9URarbSPrZw=";
  };

  nativeBuildInputs = [ xorg.mkfontscale ];

  installPhase = ''
    runHook preInstall

    misc="$out/share/fonts/misc"
    install -D -m 644 *.{bdf,otb,pcf} -t "$misc"
    install -D -m 644 *.ttf -t "$out/share/fonts/truetype"

    # create fonts.dir so NixOS xorg module adds to fp
    mkfontdir "$misc"

    runHook postInstall
  '';

  meta = {
    description = "Versatile bitmap font with an organic flair";
    homepage = "https://github.com/molarmanful/kirsch";
    changelog = "https://github.com/molarmanful/kirsch/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      ejiektpobehuk
    ];
  };
})
