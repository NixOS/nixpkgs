{ stdenv, buildGoModule, fetchFromGitHub, lib, installShellFiles }:

buildGoModule rec {
  pname = "jx";
  version = "2.1.155";

  src = fetchFromGitHub {
    owner = "jenkins-x";
    repo = "jx";
    rev = "v${version}";
    sha256 = "sha256-kwcmZSOA26XuSgNSHitGaMohalnLobabXf4z3ybSJtk=";
  };

  vendorHash = "sha256-ZtcCBXcJXX9ThzY6T0MhNfDDzRC9PYzRB1VyS4LLXLs=";

  doCheck = false;

  subPackages = [ "cmd/jx" ];

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s -w"
    "-X github.com/jenkins-x/jx/pkg/version.Version=${version}"
    "-X github.com/jenkins-x/jx/pkg/version.Revision=${src.rev}"
    "-X github.com/jenkins-x/jx/pkg/version.GitTreeState=clean"
  ];

  postInstall = ''
    for shell in bash zsh; do
      $out/bin/jx completion $shell > jx.$shell
      installShellCompletion jx.$shell
    done
  '';

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Command line tool for installing and using Jenkins X";
    mainProgram = "jx";
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
