{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kubeseal";
  version = "0.27.0";

  src = fetchFromGitHub {
    owner = "bitnami-labs";
    repo = "sealed-secrets";
    rev = "v${version}";
    sha256 = "sha256-Ja+z+QmdU37RC9WIczlmzJWN6enhks3jDJLQMV+kfCY=";
  };

  vendorHash = "sha256-QSF6/8FLXJrM5LAWW0NgDP6U0om2lXsOGP9qDasz+2c=";

  subPackages = [ "cmd/kubeseal" ];

  ldflags = [ "-s" "-w" "-X main.VERSION=${version}" ];

  meta = with lib; {
    description = "Kubernetes controller and tool for one-way encrypted Secrets";
    mainProgram = "kubeseal";
    homepage = "https://github.com/bitnami-labs/sealed-secrets";
    changelog = "https://github.com/bitnami-labs/sealed-secrets/blob/v${version}/RELEASE-NOTES.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ groodt ];
  };
}
