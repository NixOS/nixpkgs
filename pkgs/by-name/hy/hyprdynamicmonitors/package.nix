{
  lib,
  fetchFromGitHub,
  buildGoModule,
  installShellFiles,
  stdenv,
}:
buildGoModule (finalAttrs: {
  pname = "hyprdynamicmonitors";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "fiffeek";
    repo = "hyprdynamicmonitors";
    tag = "v${finalAttrs.version}";
    hash = "sha256-msAgix63TsGgETwJajdr//F19+UUhGCbrjinNbgMPHo=";
  };

  vendorHash = "sha256-WBK1PhhxaRa0FUAfSxtKOiesw71wy0753FYIgSlo0bE=";

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/fiffeek/hyprdynamicmonitors/cmd.Version=${finalAttrs.version}"
    "-X github.com/fiffeek/hyprdynamicmonitors/cmd.Commit=unknown"
    "-X github.com/fiffeek/hyprdynamicmonitors/cmd.BuildDate=1970-01-01T00:00:00Z"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd hyprdynamicmonitors \
      --bash <($out/bin/hyprdynamicmonitors completion bash) \
      --fish <($out/bin/hyprdynamicmonitors completion fish) \
      --zsh <($out/bin/hyprdynamicmonitors completion zsh)
  '';

  meta = {
    description = "Dynamic monitor configuration for Hyprland";
    homepage = "https://github.com/fiffeek/hyprdynamicmonitors";
    changelog = "https://github.com/fiffeek/hyprdynamicmonitors/releases/tag/v${finalAttrs.version}";
    mainProgram = "hyprdynamicmonitors";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ nukdokplex ];
  };
})
