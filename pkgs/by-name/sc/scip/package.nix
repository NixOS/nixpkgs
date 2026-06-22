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
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "sourcegraph";
    repo = "scip";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VdlOiIU36jXkxIXcC6qVM4g7RvRn7shTgXV5E7PM52M=";
  };

  vendorHash = "sha256-dDPcCOpsNGKLpkvsQh0QZb4aiQcoQGYJYhpuYdW3Du0=";

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
