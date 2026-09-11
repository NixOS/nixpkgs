{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  libredirect,
  iana-etc,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "scip";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "scip-code";
    repo = "scip";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vS4sHyeoigjd5dppdIvpHf03Z0N2f6SNeDfsiMu2Y+g=";
  };

  vendorHash = "sha256-9oBoNTCPT/7wJbL0Z4S7JSmEqVI2JIeJUCmhpdBr/QI=";

  subPackages = [ "cmd/scip" ];

  env.GOWORK = "off";

  ldflags = [
    "-s"
    "-X=main.Reproducible=true"
  ];

  nativeCheckInputs = lib.optionals stdenv.hostPlatform.isDarwin [ libredirect.hook ];

  __darwinAllowLocalNetworking = true;

  preCheck = lib.optionalString stdenv.hostPlatform.isDarwin ''
    export NIX_REDIRECTS=/etc/protocols=${iana-etc}/etc/protocols:/etc/services=${iana-etc}/etc/services
  '';

  doInstallCheck = stdenv.hostPlatform.isLinux;

  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    description = "SCIP Code Intelligence Protocol CLI";
    mainProgram = "scip";
    homepage = "https://github.com/scip-code/scip";
    changelog = "https://github.com/scip-code/scip/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nicolas-guichard ];
  };
})
