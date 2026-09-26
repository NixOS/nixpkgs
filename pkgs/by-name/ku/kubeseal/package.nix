{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "kubeseal";
  version = "0.39.1";

  src = fetchFromGitHub {
    owner = "bitnami";
    repo = "sealed-secrets";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vmvKD6Rk/xCw0hpGmus9JOG2JBStqzTSl09QGYMcOjQ=";
  };

  vendorHash = "sha256-JzBl9jOGYstoimv8bdy2t1DSvchFMl73zdxeY1Vagog=";

  subPackages = [ "cmd/kubeseal" ];

  ldflags = [
    "-s"
    "-w"
    "-X main.VERSION=${finalAttrs.version}"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Kubernetes controller and tool for one-way encrypted Secrets";
    mainProgram = "kubeseal";
    homepage = "https://github.com/bitnami/sealed-secrets";
    changelog = "https://github.com/bitnami/sealed-secrets/blob/v${finalAttrs.version}/RELEASE-NOTES.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ groodt ];
  };
})
