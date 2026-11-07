{
  lib,
  stdenvNoCC,
  buildGoLatestModule,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
}:
buildGoLatestModule (finalAttrs: {
  pname = "dux-greeter";
  version = "2.1.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "duxlabs-dev";
    repo = "dux-greeter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mmsexSe8OSUk1M1r7d14dA8g++tbk/GAqL9OqRZALQg=";
    fetchSubmodules = true;
  };

  vendorHash = "sha256-gtzhwzCoIwIeRFO4k6EKSThkLrzG0LECkQVuMVQNn88=";

  modRoot = "core";
  subPackages = [ "cmd/dms-greeter" ];

  tags = [ "withshell" ];

  # Bakes the quickshell UI into the binary
  preBuild = ''
    make sync-shell
  '';

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${finalAttrs.version}"
  ];

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = lib.optionalString (stdenvNoCC.buildPlatform.canExecute stdenvNoCC.hostPlatform) ''
    installShellCompletion --cmd dms-greeter \
      --bash <($out/bin/dms-greeter completion bash) \
      --fish <($out/bin/dms-greeter completion fish) \
      --zsh <($out/bin/dms-greeter completion zsh)
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Greetd-based greeter from Dux Labs";
    homepage = "https://github.com/duxlabs-dev/dux-greeter";
    changelog = "https://github.com/duxlabs-dev/dux-greeter/releases/tag/v${finalAttrs.version}";
    platforms = lib.platforms.linux;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ johnrtitor ];
    teams = [ lib.teams.duxlabs ];
    mainProgram = "dms-greeter";
  };
})
