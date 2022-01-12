{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kube-capacity";
  version = "0.6.2";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "robscott";
    repo = pname;
    sha256 = "sha256-rpCocokLj1iJonOt3rP+n1BpijjWlTie/a7vT2dMYnA=";
  };

  vendorSha256 = "sha256-1D+nQ6WrHwJwcszCvoZ08SHX0anksdI69Jra5b9jPCY=";

  meta = with lib; {
    description =
      "A simple CLI that provides an overview of the resource requests, limits, and utilization in a Kubernetes cluster";
    homepage = "https://github.com/robscott/kube-capacity";
    changelog = "https://github.com/robscott/kube-capacity/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = [ maintainers.bryanasdev000 ];
  };
}
