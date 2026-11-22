{
  buildGoModule,
  buildPackages,
  fetchFromGitHub,
  installShellFiles,
  lib,
  stdenv,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "stern";
  version = "1.35.0";

  src = fetchFromGitHub {
    owner = "stern";
    repo = "stern";
    tag = "v${finalAttrs.version}";
    hash = "sha256-E5LydpORm2uGFG6b7XWBzhWkGkDUdU20hoH+X5Xa9tE=";
  };

  vendorHash = "sha256-a76DtJOd8SDDToiulu5Ybw9/K7p/UcVaP2xe7P/MD6E=";

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

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Multi pod and container log tailing for Kubernetes";
    changelog = "https://github.com/stern/stern/releases/tag/v${finalAttrs.version}";
    homepage = "https://github.com/stern/stern";
    license = lib.licenses.asl20;
    mainProgram = "stern";
    maintainers = with lib.maintainers; [ preisschild ];
  };
})
