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
  version = "6.0.1";

  src = fetchFromGitHub {
    owner = "sourcegraph";
    repo = "src-cli";
    rev = version;
    hash = "sha256-TL7QMfYZwukqaT1Kuzzzp2bvK34dMopC5pNhK/uGjPw=";
  };

  vendorHash = "sha256-nMIRu2MiSCbdkuDEhigX9TSS2OWCXSDI8YH+u2ifIBg=";

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
