{
  buildGoModule,
  buildPackages,
  fetchFromGitHub,
  installShellFiles,
  lib,
  stdenv,
  stern,
  testers,
}:

buildGoModule rec {
  pname = "stern";
  version = "1.33.0";

  src = fetchFromGitHub {
    owner = "stern";
    repo = "stern";
    rev = "v${version}";
    hash = "sha256-JMtdjsXUOf75Djva0qdHUGM16OuWoTLjshDz4LAfllQ=";
  };

  vendorHash = "sha256-xDkYW542V2M9CvjNBFojRw4KAhcxvlBPVJCndlF+MKw=";

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/stern/stern/cmd.version=${version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall =
    let
      stern = if stdenv.buildPlatform.canExecute stdenv.hostPlatform then "$out" else buildPackages.stern;
    in
    ''
      for shell in bash zsh fish; do
        ${stern}/bin/stern --completion $shell > stern.$shell
        installShellCompletion stern.$shell
      done
    '';

  passthru.tests.version = testers.testVersion {
    package = stern;
  };

  meta = {
    description = "Multi pod and container log tailing for Kubernetes";
    changelog = "https://github.com/stern/stern/releases/tag/v${version}";
    homepage = "https://github.com/stern/stern";
    license = lib.licenses.asl20;
    mainProgram = "stern";
    maintainers = with lib.maintainers; [
      mbode
      preisschild
    ];
  };
}
