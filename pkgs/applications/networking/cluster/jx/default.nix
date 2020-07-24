{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "jx";
  version = "2.1.90";

  src = fetchFromGitHub {
    owner = "jenkins-x";
    repo = "jx";
    rev = "v${version}";
    sha256 = "1m2gq1hh8fjgxwx2sipq56q5mlz0m3npnbsw103n2kq4xv1qf3f6";
  };

  vendorSha256 = "0kj6x7323fx1qhrlg789a21mh1fvhil7ng2fhmbmlwq0fcrngdnj";

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
