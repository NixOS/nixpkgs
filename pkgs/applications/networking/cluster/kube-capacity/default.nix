{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kube-capacity";
  version = "0.7.1";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "robscott";
    repo = pname;
    sha256 = "sha256-+1qewL8N3WTS7GW6fpL2+RPbFQQ/3DDMgShtBi+lRtg=";
  };

  vendorSha256 = "sha256-sMobdarMMktf34LbQnyZ6sgbfiJhWxWSQR0F+4x5J58=";

  meta = with lib; {
    description =
      "A simple CLI that provides an overview of the resource requests, limits, and utilization in a Kubernetes cluster";
    homepage = "https://github.com/robscott/kube-capacity";
    changelog = "https://github.com/robscott/kube-capacity/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = [ maintainers.bryanasdev000 ];
  };
}
