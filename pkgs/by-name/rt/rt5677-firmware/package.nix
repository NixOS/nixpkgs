{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "rt5677-firmware";
  version = "4.16-10";

  src = fetchFromGitHub {
    owner = "raphael";
    repo = "linux-samus";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fghU20fqKDhmisXI42t23omWYCRs0HAyzCp4c2GMZc0";
  };

  installPhase = ''
    mkdir -p $out/lib/firmware
    cp ./firmware/rt5677_elf_vad $out/lib/firmware
  '';

  meta = {
    description = "Firmware for Realtek rt5677 device";
    license = lib.licenses.unfreeRedistributableFirmware;
    maintainers = with lib.maintainers; [ zohl ];
    platforms = lib.platforms.linux;
    sourceProvenance = with lib.sourceTypes; [ binaryFirmware ];
  };
})
