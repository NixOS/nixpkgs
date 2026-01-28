{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "goa";
  version = "3.24.1";

  src = fetchFromGitHub {
    owner = "goadesign";
    repo = "goa";
    rev = "v${version}";
    hash = "sha256-Y+X0uwuSBu2EF/W/xsTwZY/VF2xmh9BivaToId/nyv0=";
  };
  vendorHash = "sha256-LYeTNsR5U5Uhl2TOsRqiC7G7cTiX4hgYAsiDSbGdC9I=";

  subPackages = [ "cmd/goa" ];

  meta = {
    description = "Design-based APIs and microservices in Go";
    mainProgram = "goa";
    homepage = "https://goa.design";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ rushmorem ];
  };
}
