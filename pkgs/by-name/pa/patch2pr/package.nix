{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  patch2pr,
}:

buildGoModule rec {
  pname = "patch2pr";
  version = "0.34.0";

  src = fetchFromGitHub {
    owner = "bluekeyes";
    repo = "patch2pr";
    rev = "v${version}";
    hash = "sha256-5Xb/M7M8PAVXMyr7dwpoT0H4BV7o6okPQQw2e273ogQ=";
  };

  vendorHash = "sha256-B/Xw8rR+cldLKHr5N6ifBRHWAzJLayiejLi/winPjKg=";

  ldflags = [
    "-X main.version=${version}"
    "-X main.commit=${src.rev}"
  ];

  passthru.tests.patch2pr-version = testers.testVersion {
    package = patch2pr;
    command = "${patch2pr.meta.mainProgram} --version";
    version = version;
  };

  meta = with lib; {
    description = "Create pull requests from patches without cloning the repository";
    homepage = "https://github.com/bluekeyes/patch2pr";
    changelog = "https://github.com/bluekeyes/patch2pr/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ katrinafyi ];
    mainProgram = "patch2pr";
  };
}
