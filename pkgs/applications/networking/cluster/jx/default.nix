{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "jx";
  version = "2.1.59";

  src = fetchFromGitHub {
    owner = "jenkins-x";
    repo = "jx";
    rev = "v${version}";
    sha256 = "0zq76lzn6fi7l4z3n36692p4snnjkkaxjzkh7w37l45wykmnscdg";
  };

  vendorSha256 = "1g3gw1ilaja97ssa0pcnbq6s9prdr31l8ar1k3lnlx7pbpnq0w9w";

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
