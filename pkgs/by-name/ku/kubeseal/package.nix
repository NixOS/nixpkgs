{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "kubeseal";
  version = "0.34.0";

  src = fetchFromGitHub {
    owner = "bitnami-labs";
    repo = "sealed-secrets";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-Yu0fjVgYiZ+MTF8aJXjoQ8VZuD0tr6znFgYkTqIaZDU=";
  };

  vendorHash = "sha256-gvMExOJQHBid1GAroYufuYGzoZm2yVEKO3Wafvp7Ad0=";

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
