{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kube-capacity";
  version = "0.6.1";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "robscott";
    repo = pname;
    sha256 = "sha256-4UdNmuxJsPekA0y4mP302AYIFkG3ee3n99Redb/rPHw=";
  };

  vendorSha256 = "sha256-PQlOuBqn+b7fO9eHgtTAKxo3YdWmgbxx2JomklttCrM=";

  meta = with lib; {
    description =
      "A simple CLI that provides an overview of the resource requests, limits, and utilization in a Kubernetes cluster";
    homepage = "https://github.com/robscott/kube-capacity";
    changelog = "https://github.com/robscott/kube-capacity/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = [ maintainers.bryanasdev000 ];
  };
}
