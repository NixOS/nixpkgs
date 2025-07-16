{ lib, buildGoModule, fetchFromGitHub, installShellFiles, tmux, gh
, versionCheckHook, }:

buildGoModule (finalAttrs: {
  pname = "claude-squad";
  version = "1.0.8";

  src = fetchFromGitHub {
    owner = "smtg-ai";
    repo = "claude-squad";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mzW9Z+QN4EQ3JLFD3uTDT2/c+ZGLzMqngl3o5TVBZN0=";
  };

  vendorHash = "sha256-BduH6Vu+p5iFe1N5svZRsb9QuFlhf7usBjMsOtRn2nQ=";

  ldflags = [ "-w" "-X main.version=${finalAttrs.version}" ];

  nativeBuildInputs = [
    installShellFiles
    # Prerequisites for claude-squad
    tmux # terminal multiplexer for isolated agent sessions
    gh # GitHub CLI for git workspace interactions
  ];

  postInstall = ''
    mv $out/bin/claude-squad $out/bin/cs

    installShellCompletion --cmd cs \
      --bash <($out/bin/cs completion bash) \
      --fish <($out/bin/cs completion fish) \
      --zsh <($out/bin/cs completion zsh)
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/cs";
  versionCheckProgramArg = "version";

  meta = {
    description =
      "Terminal application for managing multiple AI coding agents in isolated workspaces";
    homepage = "https://github.com/smtg-ai/claude-squad";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ benjaminkitt ];
    mainProgram = "cs";
    platforms = lib.platforms.unix;
  };
})
