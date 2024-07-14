{ lib
, buildGoModule
, fetchFromGitHub
, testers
, patch2pr
}:

buildGoModule rec {
  pname = "patch2pr";
  version = "0.25.0";

  src = fetchFromGitHub {
    owner = "bluekeyes";
    repo = "patch2pr";
    rev = "v${version}";
    hash = "sha256-mS7Yz1RPeA/pms3gGQ1oEjtzH9miIOWlf6YrrIoJk94=";
  };

  vendorHash = "sha256-XJC4rJI+adqiyFfiuyTbrAoWDiTThz7vjDZQrchDEiA=";

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
