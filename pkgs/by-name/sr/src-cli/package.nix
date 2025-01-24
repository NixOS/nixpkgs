{
  lib,
  buildGoModule,
  fetchFromGitHub,
  stdenv,
  xorg,
  darwin,
  testers,
  src-cli,
}:

buildGoModule rec {
  pname = "src-cli";
  version = "5.5.0";

  src = fetchFromGitHub {
    owner = "sourcegraph";
    repo = "src-cli";
    rev = version;
    hash = "sha256-3hj/nY66z3AjdvmdvkKTAXD8E6A4qPtLOuY7U6sKw9U=";
  };

  vendorHash = "sha256-F6TEw9hk8Fu7uY8/KW4etyZMqOb/GL/g4NV87JjfAsY=";

  subPackages = [
    "cmd/src"
  ];

  buildInputs =
    lib.optionals stdenv.hostPlatform.isLinux [
      xorg.libX11
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.apple_sdk.frameworks.Cocoa
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
