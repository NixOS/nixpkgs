{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "cni";
  version = "1.2.3";

  src = fetchFromGitHub {
    owner = "containernetworking";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-ocSc1fhbBB8YRxVVOvYMombOOkLMdfv9V4GYbf8kwIE=";
  };

  vendorHash = "sha256-/aPx8NgGkJ1irU0LGzmYTlsiX2U5or24Vl1PGHWuDyE=";

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
