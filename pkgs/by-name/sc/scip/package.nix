{
  lib,
  stdenv,
  buildGo125Module,
  fetchFromGitHub,
  libredirect,
  iana-etc,
  versionCheckHook,
}:

buildGo125Module (finalAttrs: {
  pname = "scip";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "sourcegraph";
    repo = "scip";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lpzGrTvWUXUFfmyn5z4rsqJEcAOA8D1qfN1assRAdn4=";
  };

  vendorHash = "sha256-ARfsSW/d2bb4Lp6hedSmMerr3LrkuTfUCi569hI6eYY=";

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
    homepage = "https://github.com/sourcegraph/scip";
    changelog = "https://github.com/sourcegraph/scip/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
})
