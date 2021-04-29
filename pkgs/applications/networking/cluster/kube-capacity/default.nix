{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kube-capacity";
  version = "0.6.0";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "robscott";
    repo = pname;
    sha256 = "sha256-IwlcxlzNNYWNANszTM+s6/SA1C2LXrydSTtAvniNKXE=";
  };

  vendorSha256 = "sha256-EgLWZs282IV1euCUCc5ucf267E2Z7GF9SgoImiGvuVM=";

  meta = with lib; {
    description =
      "A simple CLI that provides an overview of the resource requests, limits, and utilization in a Kubernetes cluster";
    homepage = "https://github.com/robscott/kube-capacity";
    changelog = "https://github.com/robscott/kube-capacity/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = [ maintainers.bryanasdev000 ];
  };
}
