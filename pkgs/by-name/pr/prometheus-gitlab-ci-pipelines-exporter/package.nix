{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "gitlab-ci-pipelines-exporter";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "mvisonneau";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-r/6tRecbLN9bX2+HYyk4tT0uNiAqtZwMoMMQUJ7niJI=";
  };

  subPackages = [ "cmd/${pname}" ];

  ldflags = [
    "-X main.version=v${version}"
  ];

  vendorHash = "sha256-k1yqPVaCRtU9qpCSBR4Mo4n+9cOCT9xyRI1Ian9rNOk=";
  doCheck = true;

  meta = {
    description = "Prometheus / OpenMetrics exporter for GitLab CI pipelines insights";
    mainProgram = "gitlab-ci-pipelines-exporter";
    homepage = "https://github.com/mvisonneau/gitlab-ci-pipelines-exporter";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      mmahut
      mvisonneau
    ];
  };
}
