{ lib, go, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "qbec";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "splunk";
    repo = "qbec";
    rev = "v${version}";
    sha256 = "0vy1cqqyga68qjbvyhsgl281qkbsvhvmwbxc93hygsxzm9kczy4p";
  };

  vendorSha256 = "15hbjghi2ifylg7nr85qlk0alsy97h9zj6hf5w84m76dla2bcjf3";

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
