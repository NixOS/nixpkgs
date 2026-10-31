{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "natscli";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "nats-io";
    repo = "natscli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DQqCux+kKIgLGhEiViYqRBaoEs1R4082i7AU0ecyLgM=";
  };

  proxyVendor = true;
  vendorHash = "sha256-mnOPjXTUD45hcwdczSWyrsm2fiXP+enHZrN1VP9amuw=";

  subPackages = [ "nats" ];

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${finalAttrs.version}"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  preCheck = ''
    # Remove tests that depend on CLI output
    substituteInPlace internal/asciigraph/asciigraph_test.go \
      --replace-fail "TestPlot" "SkipPlot"
  '';

  doInstallCheck = true;

  meta = {
    description = "NATS Command Line Interface";
    homepage = "https://github.com/nats-io/natscli";
    changelog = "https://github.com/nats-io/natscli/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      bengsparks
      fab
    ];
    mainProgram = "nats";
  };
})
