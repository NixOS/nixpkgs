{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "fluxctl";
  version = "1.20.0";

  src = fetchFromGitHub {
    owner = "weaveworks";
    repo = "flux";
    rev = version;
    sha256 = "0bfib5pg2cbip6fw45slb0h3a7qpikxsfpclzr86bcnjq60pshl1";
  };

  vendorSha256 = "0a5sv11pb2i6r0ffwaiqdhc0m7gz679yfmqw6ix9imk4ybhf4jp9";

  subPackages = [ "cmd/fluxctl" ];

  buildFlagsArray = [ "-ldflags=-s -w -X main.version=${version}" ];

  meta = with stdenv.lib; {
    description = "CLI client for Flux, the GitOps Kubernetes operator";
    homepage = "https://github.com/fluxcd/flux";
    license = licenses.asl20;
    maintainers = with maintainers; [ Gonzih filalex77 ];
  };
}
