{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "fluxctl";
  version = "1.13.3";

  src = fetchFromGitHub {
    owner = "weaveworks";
    repo = "flux";
    rev = version;
    sha256 = "0l2gc9p2jz1zyl527rr0r3qklm4j86d4biviq8a30jl9rsx6z4cy";
  };

  modSha256 = "1q5g9hd0ansdc2acpysf6wi74q50w0psrpyhk4y6mm6kjvhlcn87";

  subPackages = [ "cmd/fluxctl" ];

  meta = with stdenv.lib; {
    description = "CLI client for Flux, the GitOps Kubernetes operator";
    homepage = https://github.com/weaveworks/flux;
    license = licenses.asl20;
    maintainers = with maintainers; [ Gonzih ];
  };
}
