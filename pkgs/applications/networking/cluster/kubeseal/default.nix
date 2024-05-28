{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kubeseal";
  version = "0.26.3";

  src = fetchFromGitHub {
    owner = "bitnami-labs";
    repo = "sealed-secrets";
    rev = "v${version}";
    sha256 = "sha256-2MU1/znfp2LfojfgFPovgcJbZLtqY+6O7YKZNhPIT8k=";
  };

  vendorHash = "sha256-B50+G29ze1jPBTlFA0nvMfh25t4Xb3YCxEkPkjxKMj0=";

  subPackages = [ "cmd/kubeseal" ];

  ldflags = [ "-s" "-w" "-X main.VERSION=${version}" ];

  meta = with lib; {
    description = "A Kubernetes controller and tool for one-way encrypted Secrets";
    mainProgram = "kubeseal";
    homepage = "https://github.com/bitnami-labs/sealed-secrets";
    changelog = "https://github.com/bitnami-labs/sealed-secrets/blob/v${version}/RELEASE-NOTES.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ groodt ];
  };
}
