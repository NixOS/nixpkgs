{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  stdenv,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "glow";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = "glow";
    rev = "v${finalAttrs.version}";
    hash = "sha256-JgFJwfLzw1DS5I2x75B0IFsotJF3W9ZDHVgl+VJXFps=";
  };

  vendorHash = "sha256-hxPwlWbmIFcKTtvmryFcYZbagLNFMGbkPMkXKRf95q8=";

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
    "-X=main.Version=${finalAttrs.version}"
  ];

  doCheck = false;

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd glow \
      --bash <($out/bin/glow completion bash) \
      --fish <($out/bin/glow completion fish) \
      --zsh <($out/bin/glow completion zsh)
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Render markdown on the CLI, with pizzazz";
    homepage = "https://github.com/charmbracelet/glow";
    changelog = "https://github.com/charmbracelet/glow/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ higherorderlogic ];
    mainProgram = "glow";
  };
})
