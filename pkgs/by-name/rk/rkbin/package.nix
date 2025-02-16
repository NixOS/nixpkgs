{
  stdenv,
  lib,
  fetchFromGitHub,
  rkbin,
}:

stdenv.mkDerivation {
  pname = "rkbin";
  version = "unstable-2024.10.23";

  src = fetchFromGitHub {
    owner = "rockchip-linux";
    repo = "rkbin";
    rev = "7c35e21a8529b3758d1f051d1a5dc62aae934b2b";
    hash = "sha256-KBmO++Z1AfIKvAmx7CzXScww16Stvq2BWr2raPiR6Q8=";
  };

  installPhase = ''
    mkdir $out
    mv bin doc $out/
    cp LICENSE $out/doc/LICENSE
  '';

  passthru = {
    BL31_RK3568 = "${rkbin}/bin/rk35/rk3568_bl31_v1.44.elf";
    BL31_RK3588 = "${rkbin}/bin/rk35/rk3588_bl31_v1.47.elf";
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
