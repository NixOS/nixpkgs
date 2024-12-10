{
  stdenv,
  lib,
  fetchFromGitHub,
  rkbin,
}:

stdenv.mkDerivation {
  pname = "rkbin";
  version = "unstable-2024.02.22";

  src = fetchFromGitHub {
    owner = "rockchip-linux";
    repo = "rkbin";
    rev = "a2a0b89b6c8c612dca5ed9ed8a68db8a07f68bc0";
    hash = "sha256-U/jeUsV7bhqMw3BljmO6SI07NCDAd/+sEp3dZnyXeeA=";
  };

  installPhase = ''
    mkdir $out
    mv bin doc $out/
  '';

  passthru = {
    BL31_RK3568 = "${rkbin}/bin/rk35/rk3568_bl31_v1.44.elf";
    TPL_RK3568 = "${rkbin}/bin/rk35/rk3568_ddr_1056MHz_v1.21.bin";
    TPL_RK3588 = "${rkbin}/bin/rk35/rk3588_ddr_lp4_2112MHz_lp5_2400MHz_v1.16.bin";
  };

  meta = with lib; {
    description = "Rockchip proprietary bootloader blobs";
    homepage = "https://github.com/rockchip-linux/rkbin";
    license = licenses.unfreeRedistributable;
    maintainers = with maintainers; [ thefossguy ];
    platforms = lib.platforms.all;
  };
}
