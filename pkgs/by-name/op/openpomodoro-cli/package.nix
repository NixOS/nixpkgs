{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "openpomodoro-cli";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "open-pomodoro";
    repo = "openpomodoro-cli";
    rev = "refs/tags/v${version}";
    hash = "sha256-h/o4yxrZ8ViHhN2JS0ZJMfvcJBPCsyZ9ZQw9OmKnOfY=";
  };

  vendorHash = "sha256-BR9d/PMQ1ZUYWSDO5ID2bkTN+A+VbaLTlz5t0vbkO60=";

  ldflags = [
    "-w"
    "-s"
    "-X=main.Version=${version}"
  ];

  meta = with lib; {
    description = "Command-line Pomodoro tracker which uses the Open Pomodoro Format";
    homepage = "https://github.com/open-pomodoro/openpomodoro-cli";
    changelog = "https://github.com/open-pomodoro/openpomodoro-cli/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ gdifolco ];
    mainProgram = "openpomodoro-cli";
  };
}
