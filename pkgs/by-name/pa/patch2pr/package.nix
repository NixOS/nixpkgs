{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  patch2pr,
}:

buildGoModule rec {
  pname = "patch2pr";
  version = "0.30.0";

  src = fetchFromGitHub {
    owner = "bluekeyes";
    repo = "patch2pr";
    rev = "v${version}";
    hash = "sha256-o5GvA9602k2cnw1psWUZJZE1MVUT4GzRcoPYBJCHNtg=";
  };

  vendorHash = "sha256-DNa/OE0m/69g7b44Z/cqUtbRvrsUr6lTrww0JcTjXP8=";

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
