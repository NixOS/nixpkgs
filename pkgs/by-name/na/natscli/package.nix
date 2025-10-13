{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule rec {
  pname = "natscli";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "nats-io";
    repo = "natscli";
    tag = "v${version}";
    hash = "sha256-5iGU23HsaMuRDcy3qeCJZE3p2ikaIlLnuWyGfCAlMYQ=";
  };

  vendorHash = "sha256-8JtMcEI3UMMuTa9jmkTspjKtseIb2XUcbNuWlrkAVfg=";

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

  meta = {
    description = "NATS Command Line Interface";
    homepage = "https://github.com/nats-io/natscli";
    changelog = "https://github.com/nats-io/natscli/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "nats";
  };
}
