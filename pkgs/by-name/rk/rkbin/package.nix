{
  stdenvNoCC,
  lib,
  fetchFromGitHub,
  rkbin,
}:

stdenvNoCC.mkDerivation {
  pname = "rkbin";
  version = "0-unstable-2025-12-30";

  src = fetchFromGitHub {
    owner = "rockchip-linux";
    repo = "rkbin";
    rev = "ecb4fcbe954edf38b3ae037d5de6d9f5bccf81f4";
    hash = "sha256-U8d2cH6/TSXfBnLhh141A9wP/t6prFgwYMvwgXBf4vc=";
  };

  installPhase = ''
    mkdir $out
    mv bin doc $out/
    cp LICENSE $out/doc/LICENSE
  '';

  passthru = {
    BL31_RK3568 = "${rkbin}/bin/rk35/rk3568_bl31_v1.46.elf";
    BL31_RK3588 = "${rkbin}/bin/rk35/rk3588_bl31_v1.54.elf";
    TPL_RK3566 = "${rkbin}/bin/rk35/rk3566_ddr_1056MHz_v1.25.bin";
    TPL_RK3568 = "${rkbin}/bin/rk35/rk3568_ddr_1056MHz_v1.25.bin";
    TPL_RK3588 = "${rkbin}/bin/rk35/rk3588_ddr_lp4_2112MHz_lp5_2400MHz_v1.21.bin";
  };

  meta = {
    description = "Rockchip proprietary bootloader blobs";
    homepage = "https://github.com/rockchip-linux/rkbin";
    license = lib.licenses.unfreeRedistributableFirmware;
    maintainers = with lib.maintainers; [ thefossguy ];
    platforms = lib.platforms.all;
  };
}
