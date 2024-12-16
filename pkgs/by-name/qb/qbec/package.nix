{
  lib,
  go,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "qbec";
  version = "0.16.2";

  src = fetchFromGitHub {
    owner = "splunk";
    repo = "qbec";
    rev = "v${version}";
    sha256 = "sha256-BNVQu4SJl5JsJMEoyfq4ZIo8vGDKyNPdYrKJI/oLxeQ=";
  };

  vendorHash = "sha256-TcIiSoKIS0PX8Jk6dBpc4BJAzR7YeSu9pay/grOQs5w=";

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
