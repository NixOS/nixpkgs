{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  makeWrapper,
  python310,
  kluctl,
}:

buildGoModule rec {
  pname = "kluctl";
  version = "2.25.1";

  src = fetchFromGitHub {
    owner = "kluctl";
    repo = "kluctl";
    rev = "v${version}";
    hash = "sha256-EfzMDOIp/dfnpLTnaUkZ1sfGVtQqUgeGyHNiWIwSxQ4=";
  };

  subPackages = [ "cmd" ];

  vendorHash = "sha256-iE4fPRq2kalP53AO3YaaqbRMH4Cl6XB5UseJmepoW+4=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=v${version}"
  ];

  # Depends on docker
  doCheck = false;

  nativeBuildInputs = [
    makeWrapper
  ];

  passthru.tests.version = testers.testVersion {
    package = kluctl;
    version = "v${version}";
  };

  postInstall = ''
    mv $out/bin/{cmd,kluctl}
    wrapProgram $out/bin/kluctl \
        --set KLUCTL_USE_SYSTEM_PYTHON 1 \
        --prefix PATH : '${lib.makeBinPath [ python310 ]}'
  '';

  meta = with lib; {
    description = "Missing glue to put together large Kubernetes deployments";
    mainProgram = "kluctl";
    homepage = "https://kluctl.io/";
    license = licenses.asl20;
    maintainers = with maintainers; [
      sikmir
      netthier
    ];
  };
}
