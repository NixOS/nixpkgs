{
  lib,
  stdenvNoCC,
  fetchzip,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "explex-nf";
  version = "0.0.3";

  src = fetchzip {
    url = "https://github.com/yuru7/Explex/releases/download/v${finalAttrs.version}/Explex_NF_v${finalAttrs.version}.zip";
    hash = "sha256-X4CnYT5B7IyG1Z5Ex6CXCfX7Hz3vNb5bP+vq1Vjx8XI=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm444 ExplexConsole_NF/*.ttf -t $out/share/fonts/truetype/explex-nf-console
    install -Dm444 Explex35Console_NF/*.ttf -t $out/share/fonts/truetype/explex-nf-35console

    runHook postInstall
  '';
  meta = {
    description = "Composite font of 0xProto, IBM Plex Sans JP and nerd-fonts";
    homepage = "https://github.com/yuru7/Explex";
    changelog = "https://github.com/yuru7/Explex/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.r-aizawa ];
  };
})
