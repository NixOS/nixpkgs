{
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  lib,
  nix-update-script,
  go,
}:

buildGoModule rec {
  pname = "jx";
  version = "3.16.24";

  src = fetchFromGitHub {
    owner = "jenkins-x";
    repo = "jx";
    rev = "v${version}";
    sha256 = "sha256-0BV8wV5kL7WP6cy881D0Rpw0RPIDcI4/LQckrwk/RiQ=";
  };

  vendorHash = "sha256-YUFpTL4BXm1iZJAQcbJSXEUKT99IulxT6qz4mrbBDN0=";

  subPackages = [ "cmd" ];

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-X github.com/jenkins-x/jx/pkg/cmd/version.Version=${version}"
    "-X github.com/jenkins-x/jx/pkg/cmd/version.Revision=${src.rev}"
    "-X github.com/jenkins-x/jx/pkg/cmd/version.GoVersion=${go.version}"
    "-X github.com/jenkins-x/jx/pkg/cmd/version.GitTreeState=clean"
    "-X github.com/jenkins-x/jx/pkg/cmd/version.BuildDate=''"
  ];

  postInstall = ''
    mv $out/bin/cmd $out/bin/jx
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    broken = stdenv.hostPlatform.isDarwin;
    description = "Command line tool for installing and using Jenkins X";
    mainProgram = "jx";
    homepage = "https://jenkins-x.io";
    changelog = "https://github.com/jenkins-x/jx/releases/tag/v${version}";
    longDescription = ''
      Jenkins X provides automated CI+CD for Kubernetes with Preview
      Environments on Pull Requests using using Cloud Native pipelines
      from Tekton.
    '';
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ kalbasit ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
