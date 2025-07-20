{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "kubeaudit";
  version = "0.22.2";

  src = fetchFromGitHub {
    owner = "Shopify";
    repo = "kubeaudit";
    tag = "v${version}";
    hash = "sha256-zQAM/NtDBFJZmwJYGNuYIaxv058X0URzMByPut+18TA=";
  };

  vendorHash = "sha256-IxrAJaltg7vo3SQRC7OokSD5SM8xiX7iG8ZxKYEe9/E=";

  postInstall = ''
    mv $out/bin/cmd $out/bin/$pname
  '';

  # Tests require a running Kubernetes instance
  doCheck = false;

  meta = {
    description = "Audit tool for Kubernetes";
    homepage = "https://github.com/Shopify/kubeaudit";
    changelog = "https://github.com/Shopify/kubeaudit/releases/tag/v${version}";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "kubeaudit";
  };
}
