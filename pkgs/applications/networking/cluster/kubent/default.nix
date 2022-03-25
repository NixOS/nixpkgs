{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kubent";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "doitintl";
    repo = "kube-no-trouble";
    rev = "${version}";
    sha256 = "0pwb9g1hhfqn3rl87fg6sf07m7aviadljb05bbnd241hhlcyslv6";
  };

  vendorSha256 = "1z4cvk936l7011fbimsgpw89yqzyikw9jb4184l37mnj9hl5wpcp";

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
