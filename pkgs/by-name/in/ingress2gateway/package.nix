{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "ingress2gateway";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "kubernetes-sigs";
    repo = "ingress2gateway";
    rev = "v${version}";
    hash = "sha256-0w2ZM1g2rr46bN8BNgrkmb3tOQw0FZTMLp/koW01c5I=";
  };

  vendorHash = "sha256-7b247/9/9kdNIYuaLvKIv3RK/nzQzruMKZeheTag2sA=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "Convert Ingress resources to Gateway API resources";
    homepage = "https://github.com/kubernetes-sigs/ingress2gateway";
    license = licenses.asl20;
    maintainers = with maintainers; [ arikgrahl ];
    mainProgram = "ingress2gateway";
  };
}
