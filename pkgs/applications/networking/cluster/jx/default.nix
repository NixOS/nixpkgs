{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "jx";
  version = "2.1.121";

  src = fetchFromGitHub {
    owner = "jenkins-x";
    repo = "jx";
    rev = "v${version}";
    sha256 = "0bjpnh962w5wz4gj5my9g52dawxj8zccvpkxlxy1n7c3dkzjxx5j";
  };

  vendorSha256 = "0l9djgvnrgdnw7nsf05yq7qpzzzm3gasgh9a7dyc16pp2kxvza6k";

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
