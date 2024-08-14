{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kube-capacity";
  version = "0.8.0";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "robscott";
    repo = pname;
    sha256 = "sha256-zAwCz4Qs1OF/CdSmy9p4X9hL9iNkAH/EeSU2GgekzV8=";
  };

  vendorHash = "sha256-YME4AXpHvr1bNuc/HoHxam+7ZkwLzjhIvFSfD4hga1A=";

  meta = with lib; {
    description =
      "A simple CLI that provides an overview of the resource requests, limits, and utilization in a Kubernetes cluster";
    mainProgram = "kube-capacity";
    homepage = "https://github.com/robscott/kube-capacity";
    changelog = "https://github.com/robscott/kube-capacity/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = [ maintainers.bryanasdev000 ];
  };
}
