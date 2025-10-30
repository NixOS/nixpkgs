{
  lib,
  go,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "qbec";
  version = "0.22.0";

  src = fetchFromGitHub {
    owner = "splunk";
    repo = "qbec";
    rev = "v${version}";
    sha256 = "sha256-Sgbj7JvVZ2b1Xdhn0JtGWU+u1nH9V7Fnva6KHSCwGGk=";
  };

  vendorHash = "sha256-p7pKxlMwcW7ZomBzi2pjOh5i1n9h+zUAPhAWVO68dMA=";

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
