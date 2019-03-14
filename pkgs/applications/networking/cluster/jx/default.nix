{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  name = "jx";
  version = "1.3.967";

  src = fetchFromGitHub {
    owner = "jenkins-x";
    repo = "jx";
    rev = "v${version}";
    sha256 = "0a25m7sz134kch21bg6l86kvwl4cg6babqf57kqidq6kid1zgdaq";
  };

  patches = [
    # https://github.com/jenkins-x/jx/pull/3321
    ./3321-fix-location-of-thrift.patch
  ];

  modSha256 = "0l6ccxzfxl918hzbky5ivlw413hiwagwc2cbp3f05i21qdi5mw5p";

  subPackages = [ "cmd/jx" ];

  buildFlagsArray = ''
    -ldflags=
    -X github.com/jenkins-x/jx/pkg/version.Version=${version}
    -X github.com/jenkins-x/jx/pkg/version.Revision=${version}
  '';

  meta = with lib; {
    description = "JX is a command line tool for installing and using Jenkins X.";
    homepage = https://jenkins-x.io;
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
