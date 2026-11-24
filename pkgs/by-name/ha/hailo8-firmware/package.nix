{
  lib,
  stdenvNoCC,
  fetchurl,
  linuxPackages,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "hailo8-firmware";
  inherit (linuxPackages.hailo8) version;

  src = fetchurl {
    url = "https://hailo-hailort.s3.eu-west-2.amazonaws.com/Hailo8/${finalAttrs.version}/FW/hailo8_fw.${finalAttrs.version}.bin";
    hash = "sha256-Pr6yCZh7sOSENTviN3TTiTkI3oQGkBbE43NhyHHYQzo=";
  };

  # Require review if a new firmware release changes the license text.
  firmwareEula = fetchurl {
    name = "hailo-firmware-eula-${finalAttrs.version}";
    url = "https://raw.githubusercontent.com/hailo-ai/hailort/v${finalAttrs.version}/hailort/hailo_firmware_eula";
    hash = "sha256-uaHLTHRuj7Eu1A3qQifuh5PCECrVNr5VqEE51JhMirg=";
  };

  dontUnpack = true;
  dontBuild = true;
  dontFixup = true;

  strictDeps = true;

  installPhase = ''
    runHook preInstall

    install -Dm644 "$src" "$out/lib/firmware/hailo/hailo8_fw.bin"
    install -Dm644 ${finalAttrs.firmwareEula} "$out/share/licenses/$pname/LICENSE"

    runHook postInstall
  '';

  __structuredAttrs = true;

  meta = {
    description = "Hailo 8 AI Accelerator firmware";
    downloadPage = "https://github.com/hailo-ai/hailort-drivers/blob/hailo8/download_firmware.sh";
    license = lib.licenses.mkLicense {
      shortName = "hailoEula";
      fullName = "Hailo Firmware EULA";
      url = "https://github.com/hailo-ai/hailort/blob/v${finalAttrs.version}/hailort/hailo_firmware_eula";
      free = false;
      redistributable = true;
    };
    sourceProvenance = [ lib.sourceTypes.binaryFirmware ];
    inherit (linuxPackages.hailo8.meta) maintainers;
  };
})
