{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "grafterm";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "slok";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-0pM36rAmwx/P1KAlmVaGoSj8eb9JucYycNC2R867dVo=";
  };

  vendorHash = "sha256-veg5B68AQhkSZg8YA/e4FbqJNG0YGwnUQFsAdscz0QI=";

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${version}"
  ];

  meta = with lib; {
    description = "Command-line tool for rendering metrics dashboards inspired by Grafana";
    homepage = "https://github.com/slok/grafterm";
    license = licenses.asl20;
    maintainers = with maintainers; [ arikgrahl ];
    mainProgram = "grafterm";
  };
}
