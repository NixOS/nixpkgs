{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "limesctl";
  version = "3.1.1";

  src = fetchFromGitHub {
    owner = "sapcc";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-/CYZMuW5/YoZszTOaQZLRhJdZAGGMY+s7vMK01hyMvg=";
  };

  vendorSha256 = "sha256-BwhbvCUOOp5ZeY/22kIZ58e+iPH0pVgiNOyoD6O2zPo=";

  subPackages = [ "." ];

  meta = with lib; {
    description = "CLI for Limes";
    homepage = "https://github.com/sapcc/limesctl";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
