{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "fluxctl";
  version = "1.19.0";

  src = fetchFromGitHub {
    owner = "weaveworks";
    repo = "flux";
    rev = version;
    sha256 = "1w6ndp0nrpps6pkxnq38hikbnzwahi6j9gn8l0bxd0qkf7cjc5w0";
  };

  vendorSha256 = "0w5l1lkzx4frllflkbilj8qqwf54wkz7hin7q8xn1vflkv3lxcnp";

  subPackages = [ "cmd/fluxctl" ];

  buildFlagsArray = [ "-ldflags=-s -w -X main.version=${version}" ];

  meta = with stdenv.lib; {
    description = "CLI client for Flux, the GitOps Kubernetes operator";
    homepage = "https://github.com/fluxcd/flux";
    license = licenses.asl20;
    maintainers = with maintainers; [ Gonzih filalex77 ];
  };
}