{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "buildkite-cli";
  version = "3.4.1";

  src = fetchFromGitHub {
    owner = "buildkite";
    repo = "cli";
    rev = "v${version}";
    sha256 = "sha256-4gg0x0Brw1BQLVZ9S3WRXnvOiwvuedj47OBhfSiRMyQ=";
  };

  vendorHash = "sha256-xSueBahhzD6sIFyRwvsu5ACgC9kHthDqGJ4qdNTZfPU=";

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
