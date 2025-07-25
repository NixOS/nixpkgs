{
  stdenvNoCC,
  lib,
  fetchFromGitHub,
  rkbin,
}:

stdenvNoCC.mkDerivation {
  pname = "rkbin";
  version = "0-unstable-2025-01-24";

  src = fetchFromGitHub {
    owner = "rockchip-linux";
    repo = "rkbin";
    rev = "f43a462e7a1429a9d407ae52b4745033034a6cf9";
    hash = "sha256-geESfZP8ynpUz/i/thpaimYo3kzqkBX95gQhMBzNbmk=";
  };

  installPhase = ''
    mkdir $out
    mv bin doc $out/
    cp LICENSE $out/doc/LICENSE
  '';

  passthru = {
    BL31_RK3568 = "${rkbin}/bin/rk35/rk3568_bl31_v1.44.elf";
    BL31_RK3588 = "${rkbin}/bin/rk35/rk3588_bl31_v1.48.elf";
    TPL_RK3566 = "${rkbin}/bin/rk35/rk3566_ddr_1056MHz_v1.23.bin";
    TPL_RK3568 = "${rkbin}/bin/rk35/rk3568_ddr_1056MHz_v1.23.bin";
    TPL_RK3588 = "${rkbin}/bin/rk35/rk3588_ddr_lp4_2112MHz_lp5_2400MHz_v1.18.bin";
  };

  meta = with lib; {
    description = "Rockchip proprietary bootloader blobs";
    homepage = "https://github.com/rockchip-linux/rkbin";
    license = licenses.unfreeRedistributableFirmware;
    maintainers = with maintainers; [ thefossguy ];
    platforms = lib.platforms.all;
  };
}
