{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation {
  pname = "raspberrypi-wireless-firmware";
  version = "0-unstable-2025-04-08";

  srcs = [
    (fetchFromGitHub {
      name = "bluez-firmware";
      owner = "RPi-Distro";
      repo = "bluez-firmware";
      rev = "2bbfb8438e824f5f61dae3f6ebb367a6129a4d63";
      hash = "sha256-t+D4VUfEIov83KV4wiKp6TqXTHXGkxg/mANi4GW7QHs=";
    })
    (fetchFromGitHub {
      name = "firmware-nonfree";
      owner = "RPi-Distro";
      repo = "firmware-nonfree";
      rev = "c9d3ae6584ab79d19a4f94ccf701e888f9f87a53";
      hash = "sha256-5ywIPs3lpmqVOVP3B75H577fYkkucDqB7htY2U1DW8U=";
    })
  ];

  sourceRoot = ".";

  dontBuild = true;
  # Firmware blobs do not need fixing and should not be modified
  dontFixup = true;

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/lib/firmware/brcm"

    # Wifi firmware
    cp -rv "$NIX_BUILD_TOP/firmware-nonfree/debian/config/brcm80211/." "$out/lib/firmware/"

    # Bluetooth firmware
    cp -rv "$NIX_BUILD_TOP/bluez-firmware/debian/firmware/broadcom/." "$out/lib/firmware/brcm"

    # brcmfmac43455-sdio.bin is a symlink to the non-existent path: ../cypress/cyfmac43455-sdio.bin.
    # See https://github.com/RPi-Distro/firmware-nonfree/issues/26
    ln -s "./cyfmac43455-sdio-standard.bin" "$out/lib/firmware/cypress/cyfmac43455-sdio.bin"

    pushd $out/lib/firmware/brcm &>/dev/null
    # Symlinks for Zero 2W
    ln -s "./brcmfmac43436-sdio.clm_blob" "$out/lib/firmware/brcm/brcmfmac43430b0-sdio.clm_blob"
    popd &>/dev/null

    runHook postInstall
  '';

  meta = {
    description = "Firmware for builtin Wifi/Bluetooth devices in the Raspberry Pi 3+ and Zero W";
    homepage = "https://github.com/RPi-Distro/firmware-nonfree";
    license = lib.licenses.unfreeRedistributableFirmware;
    maintainers = with lib.maintainers; [ lopsided98 ];
    platforms = lib.platforms.linux;
    sourceProvenance = with lib.sourceTypes; [ binaryFirmware ];
  };
}
