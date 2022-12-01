{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "firectl";
  # The latest upstream 0.1.0 is incompatible with firecracker
  # v0.1.0. See issue: https://github.com/firecracker-microvm/firectl/issues/82
  version = "unstable-2022-07-12";

  src = fetchFromGitHub {
    owner = "firecracker-microvm";
    repo = pname;
    rev = "ec72798240c0561dea8341d828e8c72bb0cc36c5";
    sha256 = "sha256-RAl1DaeMR7eYYwqVAvm6nib5gEGaM/t7TR8u1IpqOIM=";
  };

  vendorSha256 = "sha256-dXAJOifRtzcTyGzUTFu9+daGAlL/5dQSwcjerkZDuKA=";

  doCheck = false;

  meta = with lib; {
    description = "A command-line tool to run Firecracker microVMs";
    homepage = "https://github.com/firecracker-microvm/firectl";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ xrelkd ];
  };
}
