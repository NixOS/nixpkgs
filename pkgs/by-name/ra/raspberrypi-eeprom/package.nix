{ stdenvNoCC
, lib
, fetchFromGitHub
, makeWrapper
, python3
, binutils-unwrapped
, findutils
, gawk
, kmod
, pciutils
, libraspberrypi
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "raspberrypi-eeprom";
  version = "2024.09.10-2712";

  src = fetchFromGitHub {
    owner = "raspberrypi";
    repo = "rpi-eeprom";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-SLPLZzSRsPDxGtFnFFu99z3HqGDLDNuMWbgUKdeJyuI=";
  };

  buildInputs = [ python3 ];
  nativeBuildInputs = [ makeWrapper ];

  postPatch = ''
    # Don't try to verify md5 signatures from /var/lib/dpkg and
    # fix path to the configuration.
    substituteInPlace rpi-eeprom-update \
      --replace 'IGNORE_DPKG_CHECKSUMS=''${LOCAL_MODE}' 'IGNORE_DPKG_CHECKSUMS=1' \
      --replace '/etc/default' '/etc'
  '';

  installPhase = ''
    mkdir -p "$out/bin"
    cp rpi-eeprom-config rpi-eeprom-update rpi-eeprom-digest "$out/bin"

    mkdir -p "$out/lib/firmware/raspberrypi"
    for dirname in firmware-*; do
        dirname_suffix="''${dirname/#firmware-}"
        cp -rP "$dirname" "$out/lib/firmware/raspberrypi/bootloader-$dirname_suffix"
    done
  '';

  fixupPhase = ''
    patchShebangs $out/bin
    for i in rpi-eeprom-update rpi-eeprom-config; do
      wrapProgram $out/bin/$i \
        --set FIRMWARE_ROOT "$out/lib/firmware/raspberrypi/bootloader" \
        ${lib.optionalString stdenvNoCC.isAarch64 "--set VCMAILBOX ${libraspberrypi}/bin/vcmailbox"} \
        --prefix PATH : "${lib.makeBinPath ([
          binutils-unwrapped
          findutils
          gawk
          kmod
          pciutils
          (placeholder "out")
        ] ++ lib.optionals stdenvNoCC.isAarch64 [
          libraspberrypi
        ])}"
    done
  '';

  meta = with lib; {
    description = "Installation scripts and binaries for the closed sourced Raspberry Pi 4 and 5 bootloader EEPROMs";
    homepage = "https://www.raspberrypi.com/documentation/computers/raspberry-pi.html#raspberry-pi-4-boot-eeprom";
    license = with licenses; [ bsd3 unfreeRedistributableFirmware ];
    maintainers = with maintainers; [ das_j Luflosi ];
    platforms = platforms.linux;
  };
})
