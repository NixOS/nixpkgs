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
  version = "2.26.0";

  src = fetchFromGitHub {
    owner = "kluctl";
    repo = "kluctl";
    rev = "v${version}";
    hash = "sha256-qtntImc+fiRPMUHVM4A8d2e17zklV47CJ10M9A8oa7k=";
  };

  subPackages = [ "cmd" ];

  vendorHash = "sha256-89VEYX8xBdV36hHNIaRP8JoXTEGXmgzL7iL/Y4+1mzA=";

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
