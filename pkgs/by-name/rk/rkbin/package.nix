{
  stdenvNoCC,
  lib,
  fetchFromGitHub,
  rkbin,
}:

stdenvNoCC.mkDerivation {
  pname = "rkbin";
  version = "0-unstable-2025-06-13";

  src = fetchFromGitHub {
    owner = "rockchip-linux";
    repo = "rkbin";
    rev = "74213af1e952c4683d2e35952507133b61394862";
    hash = "sha256-gNCZwJd9pjisk6vmvtRNyGSBFfAYOADTa5Nd6Zk+qEk=";
  };

  installPhase = ''
    mkdir $out
    mv bin doc $out/
    cp LICENSE $out/doc/LICENSE
  '';

  passthru = {
    BL31_RK3568 = "${rkbin}/bin/rk35/rk3568_bl31_v1.45.elf";
    BL31_RK3588 = "${rkbin}/bin/rk35/rk3588_bl31_v1.51.elf";
    TPL_RK3566 = "${rkbin}/bin/rk35/rk3566_ddr_1056MHz_v1.23.bin";
    TPL_RK3568 = "${rkbin}/bin/rk35/rk3568_ddr_1056MHz_v1.23.bin";
    TPL_RK3588 = "${rkbin}/bin/rk35/rk3588_ddr_lp4_2112MHz_lp5_2400MHz_v1.19.bin";
  };

  meta = {
    description = "Rockchip proprietary bootloader blobs";
    homepage = "https://github.com/rockchip-linux/rkbin";
    license = lib.licenses.unfreeRedistributableFirmware;
    maintainers = with lib.maintainers; [ thefossguy ];
    platforms = lib.platforms.all;
  };
}
