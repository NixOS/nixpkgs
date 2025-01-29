{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "kubeseal";
  version = "0.28.0";

  src = fetchFromGitHub {
    owner = "bitnami-labs";
    repo = "sealed-secrets";
    rev = "v${version}";
    sha256 = "sha256-YyiYryNLSY8XnrA+3AWeQR2p55YNHFfp/sWCevATdZ0=";
  };

  vendorHash = "sha256-jul74GJivJnL3wjHOqpweezMPZwf8RnLkqkYO44mtHo=";

  subPackages = [ "cmd/kubeseal" ];

  ldflags = [
    "-s"
    "-w"
    "-X main.VERSION=${version}"
  ];

  meta = with lib; {
    description = "Kubernetes controller and tool for one-way encrypted Secrets";
    mainProgram = "kubeseal";
    homepage = "https://github.com/bitnami-labs/sealed-secrets";
    changelog = "https://github.com/bitnami-labs/sealed-secrets/blob/v${version}/RELEASE-NOTES.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ groodt ];
  };
}
