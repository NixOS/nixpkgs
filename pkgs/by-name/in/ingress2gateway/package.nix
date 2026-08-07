{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "ingress2gateway";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "kubernetes-sigs";
    repo = "ingress2gateway";
    rev = "v${finalAttrs.version}";
    hash = "sha256-pX/4WFqYkBPnaEki3q3CahBCePUvKQzVulT+oMtUXQc=";
  };

  vendorHash = "sha256-NlQbjKU5EoNY70ziDs98394LSxSIyTGsGgP1S22ynDA=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Convert Ingress resources to Gateway API resources";
    homepage = "https://github.com/kubernetes-sigs/ingress2gateway";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ arikgrahl ];
    mainProgram = "ingress2gateway";
  };
})
