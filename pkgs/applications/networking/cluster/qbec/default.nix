{ lib, go, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "qbec";
  version = "0.14.8";

  src = fetchFromGitHub {
    owner = "splunk";
    repo = "qbec";
    rev = "v${version}";
    sha256 = "sha256-awuYmazBx7zv/WuDsePzdWNRcpAzLK7lf4L2W2Jbt3A=";
  };

  vendorSha256 = "sha256-VOBRQJzATaY9DNRhZvYTRpoISikbzUAwS/1hUfce/44=";

  doCheck = false;

  ldflags = [
    "-s" "-w"
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
