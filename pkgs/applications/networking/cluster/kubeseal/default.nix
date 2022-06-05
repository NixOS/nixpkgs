{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kubeseal";
  version = "0.17.5";

  src = fetchFromGitHub {
    owner = "bitnami-labs";
    repo = "sealed-secrets";
    rev = "v${version}";
    sha256 = "0wrsfbsjf74qss4mfhjpc1h4lhfmwib83bd2i28g4yd00qq958vj";
  };

  vendorSha256 = "sha256-/rZRDH5Id8ft2oe0U/uhEgBgb0nhaQ8O5wjrSftvBzA=";

  subPackages = [ "cmd/kubeseal" ];

  ldflags = [ "-s" "-w" "-X main.VERSION=${version}" ];

  meta = with lib; {
    description = "A Kubernetes controller and tool for one-way encrypted Secrets";
    homepage = "https://github.com/bitnami-labs/sealed-secrets";
    license = licenses.asl20;
    maintainers = with maintainers; [ groodt ];
  };
}
