{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kube-score";
  version = "1.14.0";

  src = fetchFromGitHub {
    owner = "zegl";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-6/+S1aj2qoUPz+6+8Z4Z5dpfyOi/DnrLLUpPgBn/OxU=";
  };

  vendorSha256 = "sha256-0Zi62FmX4rFl3os2ehtussSSUPJtxLq7622CEdeKZCs=";

  meta = with lib; {
    description = "Kubernetes object analysis with recommendations for improved reliability and security";
    homepage    = "https://github.com/zegl/kube-score";
    license     = licenses.mit;
    maintainers = [ maintainers.j4m3s ];
  };
}
