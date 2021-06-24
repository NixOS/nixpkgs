{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kube-capacity";
  version = "0.5.1";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "robscott";
    repo = pname;
    sha256 = "127583hmpj04y522wir76a39frm6zg9z7mb4ny5lxxjqhn0q0cd5";
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
