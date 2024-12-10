{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "cni";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "containernetworking";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-32rmfBjPtc9w+B8PIb8sFOIlzZ7PnS6XSZRNLreMVl4=";
  };

  vendorHash = "sha256-JWaQacekMQGT710U5UgiIpmEYgyUCh1uks5eSV5nhWc=";

  subPackages = [
    "./cnitool"
  ];

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "Container Network Interface - networking for Linux containers";
    mainProgram = "cnitool";
    license = licenses.asl20;
    homepage = "https://github.com/containernetworking/cni";
    maintainers = with maintainers; [
      offline
      vdemeester
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
}
