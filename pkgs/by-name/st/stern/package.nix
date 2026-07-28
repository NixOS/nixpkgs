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

buildGoModule (finalAttrs: {
  pname = "stern";
  version = "1.34.0";

  src = fetchFromGitHub {
    owner = "stern";
    repo = "stern";
    rev = "v${finalAttrs.version}";
    hash = "sha256-zr3htHOxoE+9LE+nR1Lr9gEYL7M5qBpXFd0RIt9OaS4=";
  };

  vendorHash = "sha256-CN0xMhGusZmA/MGKIjNH6orXcUttfZ+3vNbz2tAnuOo=";

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/stern/stern/cmd.version=${finalAttrs.version}"
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
    changelog = "https://github.com/stern/stern/releases/tag/v${finalAttrs.version}";
    homepage = "https://github.com/stern/stern";
    license = lib.licenses.asl20;
    mainProgram = "stern";
    maintainers = with lib.maintainers; [
      mbode
      preisschild
    ];
  };
})
