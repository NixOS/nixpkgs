{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "kubefwd";
  version = "1.22.5";

  src = fetchFromGitHub {
    owner = "txn2";
    repo = "kubefwd";
    rev = version;
    hash = "sha256-xTd/1h9fW2GbZ2u3RsExbQouRZot9CUDuqNLItRySxM=";
  };

  vendorHash = "sha256-qAlzgPw1reDZYK+InlnAsBgVemVumWwLgEuYm+ALcCs=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.Version=${version}"
  ];

  meta = with lib; {
    description = "Bulk port forwarding Kubernetes services for local development";
    homepage = "https://github.com/txn2/kubefwd";
    license = licenses.asl20;
    maintainers = with maintainers; [ iogamaster ];
    mainProgram = "kubefwd";
  };
}
