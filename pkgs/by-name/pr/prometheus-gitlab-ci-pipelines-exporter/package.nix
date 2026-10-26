{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "gitlab-ci-pipelines-exporter";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "mvisonneau";
    repo = "gitlab-ci-pipelines-exporter";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-r/6tRecbLN9bX2+HYyk4tT0uNiAqtZwMoMMQUJ7niJI=";
  };

  subPackages = [ "cmd/gitlab-ci-pipelines-exporter" ];

  ldflags = [
    "-X main.version=v${finalAttrs.version}"
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
})
