{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "ingress2gateway";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "kubernetes-sigs";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-xAoJREGktbSNGYdrmPuYG2G+xaQ+kReSSA1JBgWaPVY=";
  };

  vendorHash = "sha256-T6I8uYUaubcc1dfDu6PbQ9bDDLqGuLGXWnCZhdvkycE=";

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
}
