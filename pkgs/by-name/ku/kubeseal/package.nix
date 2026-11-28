{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "kubeseal";
  version = "0.41.2";

  src = fetchFromGitHub {
    owner = "bitnami";
    repo = "sealed-secrets";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tGxYrvtxcVeL5wk+j0RJ+B3CQchSmgXNs1pQGK2YAwY=";
  };

  vendorHash = "sha256-Huyp1EVmxuhbRruhuG3trw1mJiCvKss+s428VKLm/B8=";

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
