{
  lib,
  fetchFromGitHub,
  buildGoModule,
  testers,
  restman,
}:

buildGoModule rec {
  pname = "restman";
  version = "0.3.0";

  src = fetchFromGitHub {
    repo = "restman";
    owner = "jackMort";
    rev = "v${version}";
    hash = "sha256-KN3iahDdPSHPnGEacsmaVMRNI3mV9qrH3HyJOTtB2hA=";
  };

  vendorHash = "sha256-hXd7E6yowuY3+ZpGyCzlcqwFqFrQzXBWYRMjsrxBlwI=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  doInstallCheck = true;

  passthru.tests = {
    version = testers.testVersion {
      package = restman;
      version = "restman version ${version}";
      command = "restman --version";
    };
  };

  meta = {
    description = "CLI for streamlined RESTful API testing and management";
    homepage = "https://github.com/jackMort/Restman";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ kashw2 ];
    mainProgram = "restman";
  };
}
