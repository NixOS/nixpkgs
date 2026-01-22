{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  devspace,
}:

buildGoModule rec {
  pname = "devspace";
  version = "6.3.18";

  src = fetchFromGitHub {
    owner = "devspace-sh";
    repo = "devspace";
    rev = "v${version}";
    hash = "sha256-33uhg2OY0owgP1rzdxcZzpN0cuYPRfX8vcwCJF9MVoo=";
  };

  vendorHash = null;

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  # Check are disable since they required a working K8S cluster
  # TODO: add a nixosTest to be able to perform the package check
  doCheck = false;

  passthru.tests.version = testers.testVersion {
    package = devspace;
  };

  meta = {
    description = "Open-source developer tool for Kubernetes that lets you develop and deploy cloud-native software faster";
    homepage = "https://devspace.sh/";
    changelog = "https://github.com/devspace-sh/devspace/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ darkonion0 ];
  };
}
