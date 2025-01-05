{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "smap";
  version = "0.1.12";

  src = fetchFromGitHub {
    owner = "s0md3v";
    repo = "Smap";
    rev = version;
    hash = "sha256-GLw0zgjWnEwtwRV4vTHqGUS6TqcFhhZ1zeThKe6S0CY=";
  };

  vendorHash = "sha256-19plbD+ibjoqAA6gGhCvpO52z/VejJkRRh8ljBHN+qY=";

  subPackages = [ "cmd/smap" ];

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "A drop-in replacement for Nmap powered by shodan.io";
    homepage = "https://github.com/s0md3v/Smap";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "smap";
  };
}
