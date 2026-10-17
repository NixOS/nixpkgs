{
  lib,
  stdenvNoCC,
  fetchzip,
  installFonts,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "plangothic";
  version = "2.9.5795";

  strictDeps = true;
  __structuredAttrs = true;
  dontBuild = true;

  src = fetchzip {
    url = "https://github.com/Fitzgerald-Porthmouth-Koenigsegg/Plangothic_Project/releases/download/V${finalAttrs.version}/Plangothic-Static-V${finalAttrs.version}.zip";
    hash = "sha256-jZHiCkhEKnfcW4iIp1RWwX/a8nMnUI7hxQXJS0Bgv8o=";
    stripRoot = false;
  };

  nativeBuildInputs = [
    installFonts
  ];

  # The Static archive also contains the equivalent TTC collection.
  # Install only the standalone P1 and P2 TTF files.
  dontInstallFonts = true;

  installPhase = ''
    runHook preInstall

    installFont ttf "$out/share/fonts/truetype"

    runHook postInstall
  '';

  meta = {
    description = "CJK Unified Ideographs extension font based on Source Han Sans";
    homepage = "https://github.com/Fitzgerald-Porthmouth-Koenigsegg/Plangothic_Project";
    changelog = "https://github.com/Fitzgerald-Porthmouth-Koenigsegg/Plangothic_Project/releases/tag/V${finalAttrs.version}";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      h-yuqi
    ];
  };
})
