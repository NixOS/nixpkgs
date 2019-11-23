{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "fluxctl";
  version = "1.15.0";

  src = fetchFromGitHub {
    owner = "weaveworks";
    repo = "flux";
    rev = version;
    sha256 = "1aqcamhiivy733l2avc18b0k72sg0d8iqbsqvnj1344kqx6jgxf6";
  };

  modSha256 = "1dz1cb2513drb2lr5gbl7w05ksrq5rvkqdcjnlkdc00mypjb2ms5";

  subPackages = [ "cmd/fluxctl" ];

  meta = with stdenv.lib; {
    description = "CLI client for Flux, the GitOps Kubernetes operator";
    homepage = https://github.com/fluxcd/flux;
    license = licenses.asl20;
    maintainers = with maintainers; [ Gonzih ];
  };
}
