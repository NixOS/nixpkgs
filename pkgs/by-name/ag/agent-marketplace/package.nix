{
  lib,
  buildGo127Module,
  coreutils,
  fetchFromGitHub,
  git,
  installShellFiles,
  makeWrapper,
  nix-update-script,
  stdenv,
  versionCheckHook,
}:

buildGo127Module (finalAttrs: {
  pname = "agent-marketplace";
  version = "5.0.3";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Adyen";
    repo = "agent-marketplace";
    tag = "v${finalAttrs.version}";
    hash = "sha256-270xgdeRWuavSTF+QC5tg8AMoBep1lQ93I/QeJhHKtw=";
  };

  vendorHash = "sha256-Tq6p5zW/lXIb3UIWrvKH8LjsPcG6xmqibILyhpIRgCU=";

  env = {
    CGO_ENABLED = 0;
    GOWORK = "off";
  };

  subPackages = [ "cmd/agent-marketplace" ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
  ];

  nativeCheckInputs = [ git ];
  checkFlags = [ "-short" ];

  preCheck = ''
    # Tests inspect .gitignore using Git and run shell helpers in an isolated PATH.
    git init --quiet
    substituteInPlace cmd/agent-marketplace/process_isolated_test.go \
      --replace-fail '":/usr/bin:/bin"' '":${lib.makeBinPath [ coreutils ]}"'

    # Match the command resource, not the sandbox's /build path in status output.
    substituteInPlace cmd/agent-marketplace/status_v4_excludes_test.go \
      --replace-fail 'strings.Contains(synced, "build")' 'strings.Contains(synced, "command")'
  '';

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd agent-marketplace \
      --bash <($out/bin/agent-marketplace completion bash) \
      --fish <($out/bin/agent-marketplace completion fish) \
      --zsh <($out/bin/agent-marketplace completion zsh)
  '';

  postFixup = ''
    wrapProgram $out/bin/agent-marketplace \
      --suffix PATH : ${lib.makeBinPath [ git ]}
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Sync shared AI agent resources into AI coding tools";
    homepage = "https://github.com/Adyen/agent-marketplace";
    changelog = "https://github.com/Adyen/agent-marketplace/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ _1nv0k32 ];
    mainProgram = "agent-marketplace";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
