{
  lib,
  stdenvNoCC,
  fetchzip,
  mkfontscale,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "kirsch";
  version = "0.7.2";

  src = fetchzip {
    url = "https://github.com/molarmanful/kirsch/releases/download/v${finalAttrs.version}/kirsch-release_v${finalAttrs.version}.zip";
    hash = "sha256-olm6Q6xcfSEeWXToAs/kse9QNH8k87i8vaPblU6ICnk=";
  };

  nativeBuildInputs = [ mkfontscale ];

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
