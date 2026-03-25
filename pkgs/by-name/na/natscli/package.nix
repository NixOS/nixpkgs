{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "natscli";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "nats-io";
    repo = "natscli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RvAmILkVPGZ5NS50uXN2dUfelwIelSpgPpOaZJMpjWs=";
  };

  proxyVendor = true;
  vendorHash = "sha256-YjSURSY0oLdQWyBWoMe8V0sOrB2TXwmis/QUdB7T8E4=";

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
  versionCheckProgramArg = "--version";

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
