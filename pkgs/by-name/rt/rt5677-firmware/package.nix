{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation {
  name = "rt5677-firmware";

  src = fetchFromGitHub {
    owner = "raphael";
    repo = "linux-samus";
    rev = "995de6c2093797905fbcd79f1a3625dd3f50be37";
    sha256 = "sha256-PjPFpz4qJLC+vTomV31dA3AKGjfYjKB2ZYfUpnj61Cg=";
  };

  installPhase = ''
    mkdir -p $out/lib/firmware
    cp ./firmware/rt5677_elf_vad $out/lib/firmware
  '';

  meta = with lib; {
    description = "Firmware for Realtek rt5677 device";
    license = licenses.unfreeRedistributableFirmware;
    maintainers = [ maintainers.zohl ];
    platforms = platforms.linux;
  };
}
