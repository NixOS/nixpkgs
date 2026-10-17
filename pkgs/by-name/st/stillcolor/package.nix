{
  lib,
  fetchzip,
  stdenvNoCC,
  unzip,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  strictDeps = true;
  __structuredAttrs = true;

  pname = "stillcolor";
  version = "1.1";

  src = fetchzip {
    url = "https://github.com/aiaf/Stillcolor/releases/download/v${finalAttrs.version}/Stillcolor-v${finalAttrs.version}.zip";
    hash = "sha256-ojs5EvrH4FVWHV6VXOhQmpfH69Zmy0PGMZnEO751pi8=";
  };

  nativeBuildInputs = [ unzip ];

  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications/Stillcolor.app
    cp -R . $out/Applications/Stillcolor.app/

    runHook postInstall
  '';

  meta = {
    description = "Disable temporal dithering on your Mac with this lightweight menu bar app. Designed for Apple silicon Macs.";
    downloadPage = "https://github.com/aiaf/Stillcolor/releases";
    homepage = "https://github.com/aiaf/Stillcolor";
    license = lib.licenses.mit;
    platforms = lib.platforms.darwin;
    mainProgram = "stillcolor";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ paige ];
  };
})
