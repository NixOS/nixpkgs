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
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "scip-code";
    repo = "scip";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3iUDxZAde1aVpZNFKvuITHg/b+3+sXHQvmjq/f6AIzM=";
  };

  vendorHash = "sha256-p4/YFp+FY83c0HO+8DBI8qQu4EV0DbXa2rEdfkgfsI4=";

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
