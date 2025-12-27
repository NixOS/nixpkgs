{
  lib,
  stdenvNoCC,
  fetchurl,
  undmg-hdiutil,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "aldente";
  version = "1.36.2";

  src = fetchurl {
    url = "https://github.com/AppHouseKitchen/AlDente-Battery_Care_and_Monitoring/releases/download/${finalAttrs.version}/AlDente.dmg";
    hash = "sha256-VeNEONO7wachGgCFDybH4tGaz58xlTG10S/rvm/S/Tc=";
  };

  dontBuild = true;
  dontFixup = true;

  # dmg is APFS formatted
  nativeBuildInputs = [ undmg-hdiutil ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -a AlDente.app $out/Applications

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "macOS tool to limit maximum charging percentage";
    homepage = "https://apphousekitchen.com";
    changelog = "https://github.com/davidwernhart/aldente-charge-limiter/releases/tag/${finalAttrs.version}";
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ stepbrobd ];
    platforms = [
      "aarch64-darwin"
      "x86_64-darwin"
    ];
  };
})
