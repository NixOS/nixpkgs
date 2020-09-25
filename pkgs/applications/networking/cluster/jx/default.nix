{ buildGoModule, fetchFromGitHub, lib, installShellFiles }:

buildGoModule rec {
  pname = "jx";
  version = "2.1.138";

  src = fetchFromGitHub {
    owner = "jenkins-x";
    repo = "jx";
    rev = "v${version}";
    sha256 = "1i45gzaql6rfplliky56lrzwjnm2qzv25kgyq7gvn9c7hjaaq65b";
  };

  vendorSha256 = "1wvggarakshpw7m8h0x2zvd6bshd2kzbrjynfa113z90pgksvjng";

  doCheck = false;

  subPackages = [ "cmd/jx" ];

  nativeBuildInputs = [ installShellFiles ];

  buildFlagsArray = ''
    -ldflags=
    -s -w
    -X github.com/jenkins-x/jx/pkg/version.Version=${version}
    -X github.com/jenkins-x/jx/pkg/version.Revision=${src.rev}
    -X github.com/jenkins-x/jx/pkg/version.GitTreeState=clean
  '';

  postInstall = ''
    for shell in bash zsh; do
      $out/bin/jx completion $shell > jx.$shell
      installShellCompletion jx.$shell
    done
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
