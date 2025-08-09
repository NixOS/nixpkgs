{
  lib,
  stdenv,
  installShellFiles,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule rec {
  pname = "sidekick";
  version = "0.6.6";

  src = fetchFromGitHub {
    owner = "MightyMoud";
    repo = "sidekick";
    rev = "v${version}";
    hash = "sha256-Y/dQRix/cxV3NGqTGtRP6Bcprj0jzzOpudgm9a1UMLc=";
  };

  nativeBuildInputs = [ installShellFiles ];

  doInstallCheck = true;

  doCheck = true;

  vendorHash = "sha256-35MThhVqCcIFH2oQNw6n73JqNVr2T6mXaIJMK9LiXq8=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/mightymoud/sidekick/cmd.version=${version}"
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd sidekick \
      --bash <($out/bin/sidekick completion bash) \
      --fish <($out/bin/sidekick completion fish) \
      --zsh <($out/bin/sidekick completion zsh)
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";

  meta = {
    description = "Command-line tool designed to simplify the process of deploying and managing applications on a VPS";
    mainProgram = "sidekick";
    homepage = "https://github.com/MightyMoud/sidekick";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ nipeharefa ];
  };
}
