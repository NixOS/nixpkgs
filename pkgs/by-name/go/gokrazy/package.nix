{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "gokrazy";
  version = "0-unstable-2024-09-27";

  src = fetchFromGitHub {
    owner = "gokrazy";
    repo = "tools";
    rev = "6bec690fe5cdabca7aeec52257118d4ff7d7b060";
    hash = "sha256-EJ0qEsXhBssWUrzyhtL0So0Yaxzr843QNwoE0tppeuk=";
  };

  vendorHash = "sha256-B/46VGCbLE/6LgW2wfKoHI9cyveE6hE/AfAZzIG5J+g=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.Version=${version}"
  ];

  subPackages = [ "cmd/gok" ];

  meta = with lib; {
    description = "Turn your Go program(s) into an appliance running on the Raspberry Pi 3, Pi 4, Pi Zero 2 W, or amd64 PCs!";
    homepage = "https://github.com/gokrazy/gokrazy";
    license = licenses.bsd3;
    maintainers = with maintainers; [ shayne ];
    mainProgram = "gok";
  };
}
