{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kubeseal";
  version = "0.24.1";

  src = fetchFromGitHub {
    owner = "bitnami-labs";
    repo = "sealed-secrets";
    rev = "v${version}";
    sha256 = "sha256-L5j7+2m2zKRQ/zpmwq1OimPM6I1KmmPBzNcK+s1NIDs=";
  };

  vendorHash = "sha256-+x5wohzPYzff3jpqsvnDqElrBW867WLrl4RaLlRjkUk=";

  subPackages = [ "cmd/kubeseal" ];

  ldflags = [ "-s" "-w" "-X main.VERSION=${version}" ];

  meta = with lib; {
    description = "A Kubernetes controller and tool for one-way encrypted Secrets";
    homepage = "https://github.com/bitnami-labs/sealed-secrets";
    changelog = "https://github.com/bitnami-labs/sealed-secrets/blob/v${version}/RELEASE-NOTES.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ groodt ];
  };
}
