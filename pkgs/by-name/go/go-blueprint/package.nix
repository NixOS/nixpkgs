{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  versionCheckHook,
  stdenv,
}:

buildGoModule rec {
  pname = "go-blueprint";
  version = "0.10.11";

  src = fetchFromGitHub {
    owner = "Melkeydev";
    repo = "go-blueprint";
    rev = "v${version}";
    hash = "sha256-ahvSCu4bqzPmscHSQmaxhbUtlEL7T0T/13RY2sIGWjA=";
  };

  ldflags = [
    "-s -w -X github.com/melkeydev/go-blueprint/cmd.GoBlueprintVersion=v${version}"
  ];

  vendorHash = "sha256-WBzToupC1/O70OYHbKk7S73OEe7XRLAAbY5NoLL7xvw=";

  nativeBuildInputs = [ installShellFiles ];
  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;
  versionCheckProgramArg = "version";

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd go-blueprint \
      --bash <($out/bin/go-blueprint completion bash) \
      --fish <($out/bin/go-blueprint completion fish) \
      --zsh <($out/bin/go-blueprint completion zsh)
  '';

  meta = {
    description = "Initialize Go projects using popular frameworks";
    homepage = "https://github.com/Melkeydev/go-blueprint";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tobifroe ];
    mainProgram = "go-blueprint";
  };
}
