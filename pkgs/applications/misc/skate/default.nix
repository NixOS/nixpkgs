{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "skate";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = "skate";
    rev = "v${version}";
    sha256 = "sha256-vZps/VXNK+17quPyE1b56YXE2GsW3oB4vPi7sA8EPGE=";
  };

  vendorSha256 = "sha256-7cf/ldBli/q7aNiCO7qIw8o09hVpwDxF2h/UelP86V4=";

  doCheck = false;

  ldflags = [ "-s" "-w" "-X=main.Version=${version}" ];

  meta = with lib; {
    description = "A personal multi-machine syncable key value store";
    homepage = "https://github.com/charmbracelet/skate";
    license = licenses.mit;
    maintainers = with maintainers; [ penguwin ];
  };
}
