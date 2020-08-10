{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "fluxctl";
  version = "1.20.1";

  src = fetchFromGitHub {
    owner = "weaveworks";
    repo = "flux";
    rev = version;
    sha256 = "1l514rf7rg05prq9548ygj6z284sy85ddzrwiiqr74vz4kilg3vb";
  };

  vendorSha256 = "00qm45vfz4afj8f9hikrlk96w0rdzxqq2azhzrnzfymyiwc6jk5c";

  subPackages = [ "cmd/fluxctl" ];

  buildFlagsArray = [ "-ldflags=-s -w -X main.version=${version}" ];

  meta = with stdenv.lib; {
    description = "CLI client for Flux, the GitOps Kubernetes operator";
    homepage = "https://github.com/fluxcd/flux";
    license = licenses.asl20;
    maintainers = with maintainers; [ Gonzih filalex77 ];
  };
}
