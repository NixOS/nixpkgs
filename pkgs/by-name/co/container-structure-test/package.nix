{
  lib,
  buildGo122Module,
  fetchFromGitHub,
  testers,
  container-structure-test
}:

buildGo122Module rec {
  pname = "container-structure-test";
  version = "1.17.0";

  src = fetchFromGitHub {
    owner = "GoogleContainerTools";
    repo = "container-structure-test";
    rev = "v${version}";
    hash = "sha256-YUI5HP8u91xmYkFMdSIuwAVMVPTagEhNmoPOLpi2/Fk=";
  };

  subPackages = [ "cmd/container-structure-test" ];

  vendorHash = "sha256-2D4iqNbcaYyPiYugc+1W2aBvje2aODxe21E/mlYTmr0=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/GoogleContainerTools/container-structure-test/pkg/version.version=${version}"
  ];

  passthru.tests = {
    version = testers.testVersion {
      package = container-structure-test;
    };
  };

  meta = with lib; {
    description = "The Container Structure Tests provide a powerful framework to validate the structure of a container image.";
    homepage = "https://github.com/GoogleContainerTools/container-structure-test";
    license = licenses.asl20;
    maintainers = with maintainers; [ brpaz ];
    mainProgram = "container-structure-test";
  };
}
