{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "chart-testing";
  version = "3.5.0";

  src = fetchFromGitHub {
    owner = "helm";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-lXi778MTeVUBtepGjIkKAX1kDEaaVzQI1gTKfcpANC0=";
  };

  vendorSha256 = "sha256-pNevyTibnhUK8LSM1lVnmumFazXK86q4AZ2WKFt5jok=";

  postPatch = ''
    substituteInPlace pkg/config/config.go \
      --replace "\"/etc/ct\"," "\"$out/etc/ct\","
  '';

  ldflags = [
    "-w"
    "-s"
    "-X github.com/helm/chart-testing/v3/ct/cmd.Version=${version}"
    "-X github.com/helm/chart-testing/v3/ct/cmd.GitCommit=${src.rev}"
    "-X github.com/helm/chart-testing/v3/ct/cmd.BuildDate=19700101-00:00:00"
  ];

  postInstall = ''
    install -Dm644 -t $out/etc/ct etc/chart_schema.yaml
    install -Dm644 -t $out/etc/ct etc/lintconf.yaml
  '';

  meta = with lib; {
    description = "A tool for testing Helm charts";
    homepage = "https://github.com/helm/chart-testing";
    license = licenses.asl20;
    maintainers = with maintainers; [ atkinschang ];
  };
}
