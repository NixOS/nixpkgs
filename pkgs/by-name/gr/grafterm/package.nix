{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "grafterm";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "slok";
    repo = "grafterm";
    rev = "v${finalAttrs.version}";
    hash = "sha256-0pM36rAmwx/P1KAlmVaGoSj8eb9JucYycNC2R867dVo=";
  };

  vendorHash = "sha256-veg5B68AQhkSZg8YA/e4FbqJNG0YGwnUQFsAdscz0QI=";

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${finalAttrs.version}"
  ];

  meta = {
    description = "Command-line tool for rendering metrics dashboards inspired by Grafana";
    homepage = "https://github.com/slok/grafterm";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ arikgrahl ];
    mainProgram = "grafterm";
  };
})
