{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule rec {
  pname = "natscli";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "nats-io";
    repo = "natscli";
    tag = "v${version}";
    hash = "sha256-yYE04QayL2WeZZa2I4lThCzqalxhSGFB7LYlqSGE2SA=";
  };

  vendorHash = "sha256-WtfvuccRm6jx04jz+8MGjn4mrJ7nvtdACwyL2OjE+tc=";

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
