{
  lib,
  stdenvNoCC,
  fetchurl,
  nix-update-script,
  unzip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "alt-tab-macos";
  version = "11.3.1";

  src = fetchurl {
    url = "https://github.com/lwouis/alt-tab-macos/releases/download/v${finalAttrs.version}/AltTab-${finalAttrs.version}.zip";
    hash = "sha256-X59sFQWuT9y3/YGfG/lFoXmoeV/BjHPniDZey5Phb4w=";
  };

  sourceRoot = ".";

  nativeBuildInputs = [ unzip ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -r *.app $out/Applications

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Windows alt-tab on macOS";
    homepage = "https://alt-tab.app";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      FlameFlag
      emilytrau
      Br1ght0ne
    ];
    platforms = lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
