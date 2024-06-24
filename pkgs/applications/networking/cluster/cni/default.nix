{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "cni";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "containernetworking";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-aS7THDTpfNQPw+70ZgFzvurpq/vMKE6xSxJ19ERbtOA=";
  };

  vendorHash = "sha256-5VsJ3Osm9w09t3x0dItC2iWwbPMf/IIBOSqUfcbQKK4=";

  subPackages = [
    "./cnitool"
  ];

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Container Network Interface - networking for Linux containers";
    mainProgram = "cnitool";
    license = licenses.asl20;
    homepage = "https://github.com/containernetworking/cni";
    maintainers = with maintainers; [ offline vdemeester ];
    platforms = [ "x86_64-linux" "aarch64-linux" ];
  };
}
