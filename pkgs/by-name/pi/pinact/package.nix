{ lib
, fetchFromGitHub
, buildGo120Module
, testers
, pinact
}:

let
  pname = "pinact";
  version = "0.1.2";
  src = fetchFromGitHub {
    owner = "suzuki-shunsuke";
    repo = "pinact";
    rev = "v${version}";
    hash = "sha256-OQo21RHk0c+eARKrA2qB4NAWWanb94DOZm4b9lqDz8o=";
  };
in
buildGo120Module {
  inherit pname version src;

  vendorHash = "sha256-g7rdIE+w/pn70i8fOmAo/QGjpla3AUWm7a9MOhNmrgE=";

  doCheck = true;

  passthru.tests.version = testers.testVersion {
    package = pinact;
    command = "pinact --version";
    version = src.rev;
  };

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version} -X main.commit=${src.rev}"
  ];

  meta = with lib; {
    description = "Pin GitHub Actions versions";
    homepage = "https://github.com/suzuki-shunsuke/pinact";
    changelog = "https://github.com/suzuki-shunsuke/pinact/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = [ maintainers.kachick ];
    mainProgram = "pinact";
  };
}
