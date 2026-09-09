{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "cni";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "containernetworking";
    repo = "cni";
    rev = "v${version}";
    hash = "sha256-FOUoW15aRzdwOnEfNf73tlpssJOoR+/DLOuzCTDGgpY=";
  };

  vendorHash = "sha256-nJafpp2U7Mld6d2mRUF2I/Ns9rZ+FWONj7BGfAqmEv8=";

  subPackages = [
    "./cnitool"
  ];

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Container Network Interface - networking for Linux containers";
    mainProgram = "cnitool";
    license = lib.licenses.asl20;
    homepage = "https://github.com/containernetworking/cni";
    maintainers = with lib.maintainers; [
      vdemeester
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
}
