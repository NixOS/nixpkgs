{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kube-score";
  version = "1.11.0";

  src = fetchFromGitHub {
    owner = "zegl";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-O0RtlFkyo01kcxWSzrkhh7vvV76B7I5V19dSzaxvv4Y=";
  };

  vendorSha256 = "sha256-qFS+N0tOf3zxqs1tN6Z1EnR3qLR1FfZNfJ21NoRXek0=";

  meta = with lib; {
    description = "Kubernetes object analysis with recommendations for improved reliability and security";
    homepage    = "https://github.com/zegl/kube-score";
    license     = licenses.mit;
    maintainers = [ maintainers.j4m3s ];
  };
}
