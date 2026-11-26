{
  lib,
  stdenvNoCC,
  fetchurl,
  linuxPackages,
  ...
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "hailo1x-firmware";
  inherit (linuxPackages.hailo1x) version;

  src = fetchurl {
    url = "https://hailo-hailort.s3.eu-west-2.amazonaws.com/Hailo10H/${finalAttrs.version}/FW/hailo10h_fw.tar.gz";
    hash = "sha256-QZRSLHXEp9ziwa6+YcXYr/LzVLPd4HxGYRMIc5RTP8o=";
  };

  firmwareEula = fetchurl {
    name = "hailo-firmware-eula-${finalAttrs.version}";
    url = "https://raw.githubusercontent.com/hailo-ai/hailort/v${finalAttrs.version}/hailort/hailo_firmware_eula";
    hash = "sha256-uaHLTHRuj7Eu1A3qQifuh5PCECrVNr5VqEE51JhMirg=";
  };

  dontUnpack = true; # flat directory structure
  dontBuild = true;
  dontFixup = true;

  strictDeps = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/firmware/hailo/hailo10h
    tar -xzf $src -C $out/lib/firmware/hailo/hailo10h
    install -Dm644 ${finalAttrs.firmwareEula} $out/share/licenses/$pname/LICENSE

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
    inherit (linuxPackages.hailo1x.meta) maintainers;
  };
})
