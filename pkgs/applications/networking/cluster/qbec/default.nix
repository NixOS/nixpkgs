{ lib, go, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "qbec";
  version = "0.13.4";

  src = fetchFromGitHub {
    owner = "splunk";
    repo = "qbec";
    rev = "v${version}";
    sha256 = "sha256-jbGEkBBXb1dDv4E7vEPVyvDahz27Kpyo3taenCH/vfw=";
  };

  vendorSha256 = "sha256-rzxtLaGUl8hxcJ+GWlrkjN+f7mb0lXrtkHj/pBO8HzQ=";

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
