{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "ghqr";
  version = "0.6.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "ghqr";
    tag = "v.${finalAttrs.version}";
    hash = "sha256-rfYocQRAC+0VEn9Zlh5idhHSgvb+FyK1ZRe9ICBlXuk=";
  };

  vendorHash = "sha256-y0xTK9RYBXAY3P8ddQD9ktwxkNRkFqYirL7voMBk1UI=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/microsoft/ghqr/cmd/ghqr/commands.version=${finalAttrs.version}"
  ];

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd 'ghqr' \
      --bash <("$out/bin/ghqr" completion bash) \
      --zsh <("$out/bin/ghqr" completion zsh) \
      --fish <("$out/bin/ghqr" completion fish)
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Evaluate your enterprise and organizations with GitHub best practices";
    homepage = "https://github.com/microsoft/ghqr";
    changelog = "https://github.com/microsoft/ghqr/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ airrnot ];
    mainProgram = "ghqr";
  };
})
