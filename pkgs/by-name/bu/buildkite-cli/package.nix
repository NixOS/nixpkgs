{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "buildkite-cli";
  version = "3.3.1";

  src = fetchFromGitHub {
    owner = "buildkite";
    repo = "cli";
    rev = "v${version}";
    sha256 = "sha256-BmlGMS+IQMl5UVqqQagcrqkQ7vtwZ0bNU+Adjim3bMY=";
  };

  vendorHash = "sha256-5mpJIoGlvaeFSfq9C8+i9p4vO2RBcTOuvcYtcXjJShM=";

  doCheck = false;

  postPatch = ''
    patchShebangs .buildkite/steps/{lint,run-local}.sh
  '';

  subPackages = [ "cmd/bk" ];

  ldflags = [
    "-s"
    "-w"
    "-X main.VERSION=${version}"
  ];

  meta = with lib; {
    description = "Command line interface for Buildkite";
    homepage = "https://github.com/buildkite/cli";
    license = licenses.mit;
    maintainers = with maintainers; [ groodt ];
    mainProgram = "bk";
  };
}
