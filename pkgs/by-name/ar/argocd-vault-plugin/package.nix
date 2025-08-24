{
  buildGoModule,
  fetchFromGitHub,
  lib,
  testers,
  argocd-vault-plugin,
}:

buildGoModule rec {
  pname = "argocd-vault-plugin";
  version = "1.18.1";

  src = fetchFromGitHub {
    owner = "argoproj-labs";
    repo = "argocd-vault-plugin";
    rev = "v${version}";
    hash = "sha256-rWNR4GVivuEprdX/xhwk/9SReeJ19UWDWx8Bf8z6CTI=";
  };

  vendorHash = "sha256-iZ3WWM5p0UuKpdLq6wczLtgX01q6Vtx8j/XCAH+4POs=";

  ldflags = [
    "-X=github.com/argoproj-labs/argocd-vault-plugin/version.Version=v${version}"
    "-X=github.com/argoproj-labs/argocd-vault-plugin/version.BuildDate=1970-01-01T00:00:00Z"
    "-X=github.com/argoproj-labs/argocd-vault-plugin/version.CommitSHA=unknown"
  ];

  # integration tests require filesystem and network access for credentials
  doCheck = false;

  doInstallCheck = true;

  passthru.tests.version = testers.testVersion {
    package = argocd-vault-plugin;
    command = "argocd-vault-plugin version";
    version = "argocd-vault-plugin v${version} (unknown) BuildDate: 1970-01-01T00:00:00Z";
  };

  meta = {
    homepage = "https://argocd-vault-plugin.readthedocs.io";
    changelog = "https://github.com/argoproj-labs/argocd-vault-plugin/releases/tag/v${version}";
    description = "Argo CD plugin to retrieve secrets from Secret Management tools and inject them into Kubernetes secrets";
    mainProgram = "argocd-vault-plugin";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ urandom ];
  };
}
