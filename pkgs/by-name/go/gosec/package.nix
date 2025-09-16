{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "gosec";
  version = "2.22.8";

  src = fetchFromGitHub {
    owner = "securego";
    repo = "gosec";
    rev = "v${version}";
    hash = "sha256-Ar8j5oJshouHss062m/YhAWSFDGzTKcZHGxQtKff9Bg=";
  };

  vendorHash = "sha256-zj1v98LDyaMFmjFtUV2L02j4FSBrODZFVhzYAj4rB1Q=";

  subPackages = [
    "cmd/gosec"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${version}"
    "-X main.GitTag=${src.rev}"
    "-X main.BuildDate=unknown"
  ];

  meta = with lib; {
    homepage = "https://github.com/securego/gosec";
    description = "Golang security checker";
    mainProgram = "gosec";
    license = licenses.asl20;
    maintainers = with maintainers; [
      kalbasit
      nilp0inter
    ];
  };
}
