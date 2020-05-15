{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "jx";
  version = "2.1.31";

  src = fetchFromGitHub {
    owner = "jenkins-x";
    repo = "jx";
    rev = "v${version}";
    sha256 = "1rbdmqi6m042jxd3hhqw821l567s9zzzgp0cvx8467yfi449qipn";
  };

  vendorSha256 = "1jn636sv6ak6hngw4fpgxqm6gfay2ip6g3gafjb3m4adcc5n9f8s";

  subPackages = [ "cmd/jx" ];

  buildFlagsArray = ''
    -ldflags=
    -X github.com/jenkins-x/jx/pkg/version.Version=${version}
    -X github.com/jenkins-x/jx/pkg/version.Revision=${version}
  '';

  meta = with lib; {
    description = "JX is a command line tool for installing and using Jenkins X.";
    homepage = "https://jenkins-x.io";
    longDescription = ''
      Jenkins X provides automated CI+CD for Kubernetes with Preview
      Environments on Pull Requests using Jenkins, Knative Build, Prow,
      Skaffold and Helm.
    '';
    license = licenses.asl20 ;
    maintainers = with maintainers; [ kalbasit ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
