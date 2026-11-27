{
  lib,
  stdenvNoCC,
  fetchurl,
  undmg,
  makeWrapper,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "gamemac";
  version = "0.8.613";

  src = fetchurl {
    name = "GameHub_en_${finalAttrs.version}.dmg";
    url = "https://gamehub-cdn.masnet.cn/uploads/upgrade/20260921/4627fea6e1294a11951abf805754b28a.dmg";
    hash = "sha256-STawGSPxfFnnFEhT+XN/ehC8uSZ9LyVyJ8SW43Oh8oo=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    undmg
    makeWrapper
  ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications" "$out/bin"
    mv GameHub.app "$out/Applications/"
    makeWrapper "$out/Applications/GameHub.app/Contents/MacOS/GameHub" "$out/bin/GameHub"

    runHook postInstall
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Play mobile games natively on macOS";
    homepage = "https://www.gamemac.com/en/";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ damidoug ];
    mainProgram = "GameHub";
    platforms = lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
