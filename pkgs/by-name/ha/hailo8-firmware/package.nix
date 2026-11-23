{
  lib,
  stdenvNoCC,
  fetchurl,
  linuxPackages,
  ...
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "hailo8-firmware";
  inherit (linuxPackages.hailo8) version;

  src = fetchurl {
    url = "https://hailo-hailort.s3.eu-west-2.amazonaws.com/Hailo8/${finalAttrs.version}/FW/hailo8_fw.${finalAttrs.version}.bin";
    hash = "sha256-Pr6yCZh7sOSENTviN3TTiTkI3oQGkBbE43NhyHHYQzo=";
  };

  dontUnpack = true;
  dontBuild = true;
  dontFixup = true;

  strictDeps = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/firmware
    cp -a $src $out/lib/firmware/hailo8_fw.bin

    runHook postInstall
  '';

  __structuredAttrs = true;

  meta = {
    description = "Hailo 8 AI Accelerator firmware";
    downloadPage = "https://github.com/hailo-ai/hailort-drivers/blob/hailo8/download_firmware.sh";
    # https://github.com/hailo-ai/hailort/blob/master/hailort/hailo_firmware_eula
    license = lib.licenses.unfreeRedistributable;
    inherit (linuxPackages.hailo8.meta) maintainers;
  };
})
