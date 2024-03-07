{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "acorn";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "acorn-io";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Zw/OqN4d5iukh9oUXjczMvNKYkcGSUoDEwfti7uzZXQ=";
  };

  vendorHash = "sha256-d/1Rqh00THUwcMBWloevfKbScaWhVG5r/32Q4zYUaJg=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/acorn-io/acorn/pkg/version.Tag=v${version}"
  ];

  # integration tests require network and kubernetes master
  doCheck = false;

  meta = with lib; {
    homepage = "https://docs.acorn.io";
    changelog = "https://github.com/acorn-io/${pname}/releases/tag/v${version}";
    description = "A simple application deployment framework for Kubernetes";
    license = licenses.asl20;
    maintainers = with maintainers; [ urandom ];
  };
}
