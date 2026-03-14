{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "sql-tap";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "mickamy";
    repo = "sql-tap";
    rev = "v${finalAttrs.version}";
    hash = "sha256-FVCpkOHoLMNr9IfJ9hjGEANDM2trzlDHqjwIgtnmB+0=";
  };

  vendorHash = "sha256-zf3NxbxX8X2/ZHBDjbp+cPOviODLTTDrY1LW//3lSDk=";

  subPackages = [
    "."
    "cmd/sql-tapd"
  ];

  ldflags = [
    "-X main.version=${finalAttrs.version}"
  ];

  meta = {
    description = "Watch SQL traffic in real-time with a TUI";
    homepage = "https://github.com/mickamy/sql-tap";
    changelog = "https://github.com/mickamy/sql-tap/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Ziqi-Yang ];
    mainProgram = "sql-tap";
  };
})
