{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule rec {
  pname = "natscli";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "nats-io";
    repo = "natscli";
    tag = "v${version}";
    hash = "sha256-Ya3nNgPa9MEiDDwoBv8oXi7+Hji9fhUNIm55jJ6w++8=";
  };

  vendorHash = "sha256-NLsIX0B2YKGNWeAuKIQUs/2sXokUr6PYO5qvvfbbN1Y=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${version}"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  preCheck = ''
    # Remove tests that depend on CLI output
    substituteInPlace internal/asciigraph/asciigraph_test.go \
      --replace-fail "TestPlot" "SkipPlot"
  '';

  doInstallCheck = true;

  versionCheckProgram = "${placeholder "out"}/bin/nats";

  meta = with lib; {
    description = "NATS Command Line Interface";
    homepage = "https://github.com/nats-io/natscli";
    changelog = "https://github.com/nats-io/natscli/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
    mainProgram = "nats";
  };
}
