{ lib, go, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "qbec";
  version = "0.12.2";

  src = fetchFromGitHub {
    owner = "splunk";
    repo = "qbec";
    rev = "v${version}";
    sha256 = "10bf9ja44n1gzhb5znqbmr1xjc87akrsdyxfvrz4f5bd3p1fh6j0";
  };

  vendorSha256 = "0xkmccm6cyw1p5mah7psbpfsfaw8f09r1a2k4iksfggrn9mimaam";

  doCheck = false;

  buildFlagsArray = ''
    -ldflags=
      -s -w
      -X github.com/splunk/qbec/internal/commands.version=${version}
      -X github.com/splunk/qbec/internal/commands.commit=${src.rev}
      -X github.com/splunk/qbec/internal/commands.goVersion=${lib.getVersion go}
  '';

  meta = with lib; {
    description = "Configure kubernetes objects on multiple clusters using jsonnet https://qbec.io";
    homepage = "https://github.com/splunk/qbec";
    license = licenses.asl20;
    maintainers = with maintainers; [ groodt ];
  };
}
