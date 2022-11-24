{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kubent";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "doitintl";
    repo = "kube-no-trouble";
    rev = "${version}";
    sha256 = "sha256-aXuBYfXQfg6IQE9cFFTBCPNmDg7IZYPAAeuAxCiU0ro=";
  };

  vendorSha256 = "sha256-WQwWBcwhFZxXPFO6h+5Y8VDM4urJGfZ6AOvhRoaSbpk=";

  ldflags = [
    "-w" "-s"
    "-X main.version=v${version}"
  ];

  subPackages = [ "cmd/kubent" ];

  meta = with lib; {
    homepage = "https://github.com/doitintl/kube-no-trouble";
    description = "Easily check your cluster for use of deprecated APIs";
    license = licenses.mit;
    maintainers = with maintainers; [ peterromfeldhk ];
  };
}
