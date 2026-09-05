{
  lib,
  stdenvNoCC,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "dms-greeter";
  version = "1.6.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "AvengeMedia";
    repo = "dank-greeter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XAd81SHwl7zChwpl+PXjePzV9bejy9e2WataOZJ+ioA=";
    fetchSubmodules = true;
  };

  vendorHash = "sha256-Ort6y6BTKfuMRjDpTjY5tnCE5VAS4CItwo1U5dAvHpw=";

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
    description = "Greetd-based greeter for the Dank Material Linux suite";
    homepage = "https://github.com/AvengeMedia/dank-greeter";
    platforms = lib.platforms.linux;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ johnrtitor ];
    teams = [ lib.teams.danklinux ];
    mainProgram = "dms-greeter";
  };
})
