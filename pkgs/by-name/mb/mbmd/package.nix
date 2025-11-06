{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
let
  version = "0.13-unstable-2025-08-08";
  rev = "499ae856f44e511b236660d9dce0021f758fc64e";
  modulePath = "github.com/volkszaehler/mbmd";
in
buildGoModule {
  pname = "mbmd";
  inherit version;

  src = fetchFromGitHub {
    inherit rev;
    owner = "volkszaehler";
    repo = "mbmd";
    hash = "sha256-HdldLF9+QgaIvGG8lAENvUiPonMwrdHUphGRSmaeRj8=";
  };

  tags = [ "release" ];

  ldflags = [
    "-s"
    "-w"
    "-X ${modulePath}/server.Version=${version}"
    "-X ${modulePath}/server.Commit=${rev}"
  ];

  vendorHash = "sha256-L816AQmyL6ZctKgImbU/cAYSQkQhxuhvtr4SyjPKMFs=";

  env.CGO_ENABLED = 0; # NOTE: Pure Go

  meta = with lib; {
    description = "ModBus Measurement Daemon - simple reading of data from ModBus meters and grid inverters";
    homepage = "https://github.com/volkszaehler/mbmd";
    license = licenses.bsd3;
    maintainers = with maintainers; [ tsandrini ];
    mainProgram = "mbmd";
  };
}
