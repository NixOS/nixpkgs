{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "hackgen-nf-font";
  version = "2.10.0";

  src = fetchzip {
    url = "https://github.com/yuru7/HackGen/releases/download/v${finalAttrs.version}/HackGen_NF_v${finalAttrs.version}.zip";
    hash = "sha256-n0ibIzNIy5tUdC0QEWRRW4S5Byih39agW2IxCiqTLoQ=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 *.ttf -t $out/share/fonts/hackgen-nf

    runHook postInstall
  '';

  meta = {
    description = "Composite font of Hack, GenJyuu-Gothic and nerd-fonts";
    homepage = "https://github.com/yuru7/HackGen";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ natsukium ];
  };
})
