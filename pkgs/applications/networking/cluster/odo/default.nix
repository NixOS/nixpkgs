{ lib, buildGoModule, fetchFromGitHub, testers, odo }:

buildGoModule rec {
  pname = "odo";
  version = "3.15.0";

  src = fetchFromGitHub {
    owner = "redhat-developer";
    repo = "odo";
    rev = "v${version}";
    sha256 = "sha256-UPq211Lo95r2b/Ov/a7uhb5p9M3MlNd72VwkMXPHy2Y=";
  };

  vendorHash = null;

  buildPhase = ''
    make bin
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp -a odo $out/bin
  '';

  passthru.tests.version = testers.testVersion {
    package = odo;
    command = "odo version";
    version = "v${version}";
  };

  meta = with lib; {
    description = "Developer-focused CLI for OpenShift and Kubernetes";
    license = licenses.asl20;
    homepage = "https://odo.dev";
    changelog = "https://github.com/redhat-developer/odo/releases/v${version}";
    maintainers = with maintainers; [ stehessel ];
  };
}
