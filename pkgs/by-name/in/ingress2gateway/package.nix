{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "ingress2gateway";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "kubernetes-sigs";
    repo = "ingress2gateway";
    rev = "v${finalAttrs.version}";
    hash = "sha256-rnSkJMME0BOQYlMv8tN8CywivVOwEek6eJ46jHY7ho0=";
  };

  vendorHash = "sha256-9YV4T7sDhb/1ZgpjrIm4AWFx1OoZbY9u3jpGlCM4edc=";

  ldflags = [
    "-s"
    "-w"
    "-X"
    "github.com/kubernetes-sigs/ingress2gateway/pkg/i2gw.Version=v${finalAttrs.version}"
  ];

  excludedPackages = [ "e2e" ];

  meta = {
    description = "Convert Ingress resources to Gateway API resources";
    homepage = "https://github.com/kubernetes-sigs/ingress2gateway";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ arikgrahl ];
    mainProgram = "ingress2gateway";
  };
})
