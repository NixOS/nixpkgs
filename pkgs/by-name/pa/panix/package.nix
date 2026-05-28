{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "panix";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "mihakrumpestar";
    repo = "panix";
    rev = "v${version}";
    hash = "sha256-Nran1Kop3BXYcUFoAb97WUOOL20PqAFA4sq3N/utv2U=";
  };

  subPackages = [ "cmd/panix" ];

  flags = [ "-trimpath" ];
  ldflags = [
    "-s"
    "-w"
  ];

  env.CGO_ENABLED = 0;

  vendorHash = "sha256-S1lLVTo03NH3beLeduyyHBdPZohntCAD05E6myHIwj0=";

  meta = with lib; {
    description = "Universal NixOS Deployment Tool";
    homepage = "https://github.com/mihakrumpestar/panix";
    changelog = "https://github.com/mihakrumpestar/panix/releases/tag/v${version}";
    license = licenses.agpl3Only;
    maintainers = with lib.maintainers; [ mihakrumpestar ];
    platforms = platforms.all;
    mainProgram = "panix";
  };
}
