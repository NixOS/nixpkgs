{
  lib,
  go,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "qbec";
  version = "0.30.0";

  src = fetchFromGitHub {
    owner = "splunk";
    repo = "qbec";
    rev = "v${version}";
    sha256 = "sha256-9vHURoI4CwHcdL4spmERRJGz0dfPEdAMjWSRlxOs1N8=";
  };

  vendorHash = "sha256-raXRnuPu/t5opgU58MP4qiO1GcUcD976t4OmwHrLdc8=";

  doCheck = false;

  ldflags = [
    "-s"
    "-w"
    "-X github.com/splunk/qbec/internal/commands.version=${version}"
    "-X github.com/splunk/qbec/internal/commands.commit=${src.rev}"
    "-X github.com/splunk/qbec/internal/commands.goVersion=${lib.getVersion go}"
  ];

  meta = with lib; {
    description = "Configure kubernetes objects on multiple clusters using jsonnet https://qbec.io";
    homepage = "https://github.com/splunk/qbec";
    license = licenses.asl20;
    maintainers = with maintainers; [ groodt ];
  };
}
