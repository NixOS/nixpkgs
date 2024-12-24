{
  lib,
  go,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "qbec";
  version = "0.16.3";

  src = fetchFromGitHub {
    owner = "splunk";
    repo = "qbec";
    rev = "v${version}";
    sha256 = "sha256-zi8UPDJxa6SJslVTi6uOxph/au42LPRSCZ/oohXPYFs=";
  };

  vendorHash = "sha256-n0z4kErg0Y3uSwF8tCqM2AJs5rCuHOZONjhqMPSmeK4=";

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
