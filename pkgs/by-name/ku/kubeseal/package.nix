{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "kubeseal";
  version = "0.40.0";

  src = fetchFromGitHub {
    owner = "bitnami";
    repo = "sealed-secrets";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lhN9rIi6C3+fVnh2cv11sVYG5uxpJAIWOemyde8Xkb4=";
  };

  vendorHash = "sha256-6+SKSChuU+JZzCcPVeiQ6VhF/bCVwv2Uo4+7+h8aZVs=";

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
