{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "kubeseal";
  version = "0.36.6";

  src = fetchFromGitHub {
    owner = "bitnami-labs";
    repo = "sealed-secrets";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-H5nfFdXNbOpzPpq4PsKSi2CKb4bB5SrYWqNXgqnzuNY=";
  };

  vendorHash = "sha256-kE2zLCy4MntaCl9bhdYkt0I0eh1MJm+WYqSuXlkEMmY=";

  subPackages = [ "cmd/kubeseal" ];

  ldflags = [
    "-s"
    "-w"
    "-X main.VERSION=${finalAttrs.version}"
  ];

  meta = {
    description = "Kubernetes controller and tool for one-way encrypted Secrets";
    mainProgram = "kubeseal";
    homepage = "https://github.com/bitnami-labs/sealed-secrets";
    changelog = "https://github.com/bitnami-labs/sealed-secrets/blob/v${finalAttrs.version}/RELEASE-NOTES.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ groodt ];
  };
})
