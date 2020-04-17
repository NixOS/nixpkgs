{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kubeseal";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "bitnami-labs";
    repo = "sealed-secrets";
    rev = "v${version}";
    sha256 = "0z51iwdc4m0y8wyyx3mcvbzxlrgws7n5wkcd0g7nr73irnsld4lh";
  };

  modSha256 = "029h0zr3fpzlsv9hf1d1x5j7aalxkcsyszsxjz8fqrhjafqc7zvq";

  subPackages = [ "cmd/kubeseal" ];

  meta = with lib; {
    description = "A Kubernetes controller and tool for one-way encrypted Secrets";
    homepage = "https://github.com/bitnami-labs/sealed-secrets";
    license = licenses.asl20;
    maintainers = with maintainers; [ groodt ];
  };
}
