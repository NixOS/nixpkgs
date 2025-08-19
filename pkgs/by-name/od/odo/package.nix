{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  odo,
}:

buildGoModule rec {
  pname = "odo";
  version = "3.16.1";

  src = fetchFromGitHub {
    owner = "redhat-developer";
    repo = "odo";
    rev = "v${version}";
    sha256 = "sha256-zEN8yfjW3JHf6OzPQC6Rg2/hJ+3d9d2nYhz60BdSK9s=";
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

  meta = {
    description = "Developer-focused CLI for OpenShift and Kubernetes";
    mainProgram = "odo";
    license = lib.licenses.asl20;
    homepage = "https://odo.dev";
    changelog = "https://github.com/redhat-developer/odo/releases/v${version}";
    maintainers = with lib.maintainers; [ stehessel ];
  };
}
