{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kube-score";
  version = "1.13.0";

  src = fetchFromGitHub {
    owner = "zegl";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-QAtsXNmR+Sg9xmvP7x6b2jAJkUcL/sMYk8i5CSzjVos=";
  };

  vendorSha256 = "sha256-kPYvkovzQDmoB67TZHCKZ5jtW6pN3gHxBPKAU8prbgo=";

  meta = with lib; {
    description = "Kubernetes object analysis with recommendations for improved reliability and security";
    homepage    = "https://github.com/zegl/kube-score";
    license     = licenses.mit;
    maintainers = [ maintainers.j4m3s ];
  };
}
