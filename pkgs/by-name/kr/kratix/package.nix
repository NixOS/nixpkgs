{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  versionCheckHook,
  stdenv,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "kratix-cli";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "syntasso";
    repo = "kratix-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-n+qlYkci9Megt8SqEyScJnOLyboXxbPHc5KZUw0Fgq8=";
  };

  vendorHash = "sha256-NrNIGKUSm6mCOlLhI0rRp+GQLZ5p/aFo4/7P2pm64jY=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  subPackages = [ "cmd/kratix" ];

  nativeBuildInputs = [ installShellFiles ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  env.CGO_ENABLED = 0;

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    for shell in bash fish zsh; do
      installShellCompletion --cmd kratix \
        --$shell <($out/bin/kratix completion $shell)
    done
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CLI-based tool to build Promises";
    homepage = "https://github.com/syntasso/kratix-cli";
    changelog = "https://github.com/syntasso/kratix-cli/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      mattfield
    ];
    mainProgram = "kratix";
  };
})
