{
  lib,
  stdenvNoCC,
  fetchurl,
  unzip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "draw-things";
  version = "1.20260716.0";

  src = fetchurl rec {
    # The CDN path carries the first eight hex digits of the archive's SHA-256.
    url = "https://static.drawthings.ai/DrawThings-${finalAttrs.version}-${lib.substring 0 8 sha256}.zip";
    sha256 = "4d534b3c75b4d759d12c25458c545ed534160e1c922c726426399a6aea55aeae";
  };

  sourceRoot = ".";

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [ unzip ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications" "$out/bin"
    mv "Draw Things.app" "$out/Applications/"
    ln -s "$out/Applications/Draw Things.app/Contents/MacOS/DrawThings" \
      "$out/bin/draw-things"

    runHook postInstall
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "On-device Stable Diffusion image generator";
    longDescription = ''
      Draw Things runs Stable Diffusion and other diffusion models locally on
      Apple silicon, without an account or a network round trip. It covers
      text-to-image, image-to-image, inpainting, outpainting, ControlNet and
      LoRA, and can import models in the usual Core ML, Diffusers and
      safetensors formats.
    '';
    homepage = "https://drawthings.ai/";
    changelog = "https://releases.drawthings.ai/";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    mainProgram = "draw-things";
    maintainers = with lib.maintainers; [ dfjay ];
    platforms = lib.platforms.darwin;
  };
})
