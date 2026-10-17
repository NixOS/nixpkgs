{
  stdenvNoCC,
  lib,
  fetchFromGitHub,
  rkbin,
}:

stdenvNoCC.mkDerivation {
  pname = "rkbin";
  version = "0-unstable-2026-06-26";

  src = fetchFromGitHub {
    owner = "rockchip-linux";
    repo = "rkbin";
    rev = "3e288fe814e059dd06833495f845cab04ac20a5c";
    hash = "sha256-CgGTTGsR0ptrCffYw6A1iujOeQHvVEywqtiqTnxsZjw=";
  };

  installPhase = ''
    mkdir $out
    mv bin doc $out/
    cp LICENSE $out/doc/LICENSE
  '';

  passthru = {
    BL31_RK3568 = "${rkbin}/bin/rk35/rk3568_bl31_v1.46.elf";
    BL31_RK3588 = "${rkbin}/bin/rk35/rk3588_bl31_v1.56.elf";
    TPL_RK3566 = "${rkbin}/bin/rk35/rk3566_ddr_1056MHz_v1.26.bin";
    TPL_RK3568 = "${rkbin}/bin/rk35/rk3568_ddr_1056MHz_v1.26.bin";
    TPL_RK3588 = "${rkbin}/bin/rk35/rk3588_ddr_lp4_2112MHz_lp5_2400MHz_v1.24.bin";
  };

  meta = {
    description = "Rockchip proprietary bootloader blobs";
    homepage = "https://github.com/rockchip-linux/rkbin";
    license = lib.licenses.unfreeRedistributableFirmware;
    maintainers = with lib.maintainers; [ thefossguy ];
    platforms = lib.platforms.all;
  };
}
