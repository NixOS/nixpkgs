{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "ingress2gateway";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "kubernetes-sigs";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-+ImMpO1qRkXYLy+MDloKSoDCmMmJSBorgDjzaeSCBdY=";
  };

  vendorHash = "sha256-IEU9cfYCkrQagxzJT6jPz2nRCz1BAaiGvkEPhNRQr4E=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Convert Ingress resources to Gateway API resources";
    homepage = "https://github.com/kubernetes-sigs/ingress2gateway";
    license = licenses.asl20;
    maintainers = with maintainers; [ arikgrahl ];
    mainProgram = "ingress2gateway";
  };
}
