{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  scip,
}:

buildGoModule rec {
  pname = "scip";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "sourcegraph";
    repo = "scip";
    rev = "v${version}";
    hash = "sha256-UXa5lMFenynHRIvA4MOXkjMVd705LBWs372s3MFAc+8=";
  };

  vendorHash = "sha256-6vx3Dt0ZNR0rY5bEUF5X1hHj/gv21920bhfd+JJ9bYk=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.Reproducible=true"
  ];

  # update documentation to fix broken test
  postPatch = ''
    substituteInPlace docs/CLI.md \
      --replace 0.3.0 0.3.1
  '';

  passthru.tests = {
    version = testers.testVersion {
      package = scip;
      version = "v${version}";
    };
  };

  meta = with lib; {
    description = "SCIP Code Intelligence Protocol CLI";
    mainProgram = "scip";
    homepage = "https://github.com/sourcegraph/scip";
    changelog = "https://github.com/sourcegraph/scip/blob/${src.rev}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ figsoda ];
  };
}
