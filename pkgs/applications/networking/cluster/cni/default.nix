{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "cni";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "containernetworking";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-g7fVeoqquxPa17AfTu6wnB6PQJDluJ21T3ETrcvWtWg=";
  };

  vendorSha256 = "sha256-nH/myA/KdTeFXvmBymXITyx5fdCGnWRn6hNRinXc3/s=";

  subPackages = [
    "./cnitool"
  ];

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Container Network Interface - networking for Linux containers";
    license = licenses.asl20;
    homepage = "https://github.com/containernetworking/cni";
    maintainers = with maintainers; [ offline vdemeester ];
    platforms = [ "x86_64-linux" "aarch64-linux" ];
  };
}
