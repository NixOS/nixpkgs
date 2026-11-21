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

  dontUnpack = true; # flat directory structure
  dontBuild = true;
  dontFixup = true;

  strictDeps = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/firmware/hailo/hailo10h
    tar -xzf $src -C $out/lib/firmware/hailo/hailo10h

    runHook postInstall
  '';

  __structuredAttrs = true;

  meta = {
    description = "Hailo 8 AI Accelerator firmware";
    downloadPage = "https://github.com/hailo-ai/hailort-drivers/blob/hailo8/download_firmware.sh";
    # https://github.com/hailo-ai/hailort/blob/master/hailort/hailo_firmware_eula
    license = lib.licenses.unfreeRedistributable;
    inherit (linuxPackages.hailo1x.meta) maintainers;
  };
})
