{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kubent";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "doitintl";
    repo = "kube-no-trouble";
    rev = "${version}";
    sha256 = "sha256-QIvMhKAo30gInqJBpHvhcyjgVkdRqgBKwLQ80ng/75U=";
  };

  vendorSha256 = "sha256-XXf6CPPHVvCTZA4Ve5/wmlgXQ/gZZUW0W/jXA0bJgLA=";

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
