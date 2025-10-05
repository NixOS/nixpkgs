{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "gokrazy";
  version = "0-unstable-2025-10-03";

  src = fetchFromGitHub {
    owner = "gokrazy";
    repo = "tools";
    rev = "9a9519186b1b166c83808face703d256713017b7";
    hash = "sha256-mKbk/02ZFWYmAIbwEY6Pol0XEEDPf7T7VP7PVZhkYPc=";
  };

  vendorHash = "sha256-nmLj8uYdaUC2CBlmj+kGbBCAicVyhDmG9GnILqzmtK0=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.Version=${version}"
  ];

  subPackages = [ "cmd/gok" ];

  meta = {
    description = "Turn your Go program(s) into an appliance running on the Raspberry Pi 3, Pi 4, Pi Zero 2 W, or amd64 PCs";
    homepage = "https://github.com/gokrazy/gokrazy";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ shayne ];
    mainProgram = "gok";
  };
}
