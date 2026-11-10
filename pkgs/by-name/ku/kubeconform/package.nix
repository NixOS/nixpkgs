{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "kubeconform";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "yannh";
    repo = "kubeconform";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-HcYKmit67ZGABDfpr281FiStMZmM/vkkj9wxXH5H9zc=";
  };

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
    "-X main.version=v${finalAttrs.version}"
  ];

  vendorHash = null;

  excludedPackages = [ "./openapi2jsonschema-go" ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;

  versionCheckProgramArg = "-v";

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "FAST Kubernetes manifests validator, with support for Custom Resources";
    mainProgram = "kubeconform";
    homepage = "https://github.com/yannh/kubeconform/";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.j4m3s ];
  };
})
