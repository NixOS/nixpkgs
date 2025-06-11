{
  lib,
  buildGoModule,
  fetchFromGitHub,
  stdenv,
  xorg,
  testers,
  src-cli,
}:

buildGoModule rec {
  pname = "src-cli";
  version = "6.3.0";

  src = fetchFromGitHub {
    owner = "sourcegraph";
    repo = "src-cli";
    rev = version;
    hash = "sha256-MAeL33uu53qtL8TC7YNHkeL/PG8t/Iv+P+ftqd/TTFI=";
  };

  vendorHash = "sha256-bpfDnVqJoJi9WhlA6TDWAhBRkbbQn1BHfnLJ8BTmhGM=";

  subPackages = [
    "cmd/src"
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    xorg.libX11
  ];

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/sourcegraph/src-cli/internal/version.BuildTag=${version}"
  ];

  __darwinAllowLocalNetworking = true;

  passthru.tests = {
    version = testers.testVersion {
      package = src-cli;
      command = "src version || true";
    };
  };

  meta = with lib; {
    description = "Sourcegraph CLI";
    homepage = "https://github.com/sourcegraph/src-cli";
    changelog = "https://github.com/sourcegraph/src-cli/blob/${src.rev}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "src";
  };
}
