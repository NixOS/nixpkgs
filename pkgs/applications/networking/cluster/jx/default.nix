{ buildGoModule, fetchFromGitHub, lib, installShellFiles }:

buildGoModule rec {
  pname = "jx";
  version = "2.1.127";

  src = fetchFromGitHub {
    owner = "jenkins-x";
    repo = "jx";
    rev = "v${version}";
    sha256 = "01dfpnqgbrn8b6h2irq080xdm76b4jx6sd80f8x4zmyaz6hf5vlv";
  };

  vendorSha256 = "0la92a8720l8my5r4wsbgv74y6m19ikmm0wv3l4m4w5gjyplfsxb";

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
