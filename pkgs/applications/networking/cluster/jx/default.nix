{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "jx";
  version = "2.1.65";

  src = fetchFromGitHub {
    owner = "jenkins-x";
    repo = "jx";
    rev = "v${version}";
    sha256 = "0zkp0z5qpqw44bjnl20xna7s251k7jsxccqnqkdqqrzmqjpkkwgx";
  };

  vendorSha256 = "0zi2n8fywzy87yfwcx7di74s8mx0468zmg6kwjln7mwhr6q23adf";

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
