{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "fluxctl";
  version = "1.13.1";

  src = fetchFromGitHub {
    owner = "weaveworks";
    repo = "flux";
    rev = version;
    sha256 = "0g8yfvwh6hjh70a0i4ssbb6hq3i9f75wj8yqy1aaafycq598zbdx";
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
