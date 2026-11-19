{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "envdiff";
  version = "0.2.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "GBerghoff";
    repo = "envdiff";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0XOUk9C5xOM+4530HoU43yfAnSW/Uw1MMln8DJI/fWc=";
  };

  vendorHash = "sha256-FQBp6kd/rOKdfleOrfW/gEbyTjGQhdDKhkFvLFFqyq0=";

  ldflags = [
    "-s"
    "-X=main.version=${finalAttrs.version}"
  ];

  checkFlags = lib.optionals stdenv.hostPlatform.isDarwin [
    # Shells out to `sysctl` (/usr/sbin) which is not available in the sandbox:
    # MemoryGB should be positive
    "-skip=^TestSystemCollector_Collect$"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd envdiff \
      --bash <($out/bin/envdiff completion bash) \
      --fish <($out/bin/envdiff completion fish) \
      --zsh <($out/bin/envdiff completion zsh)
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Cli tool to snapshot and diff environments - helping find the differences that matter";
    homepage = "https://github.com/GBerghoff/envdiff";
    changelog = "https://github.com/GBerghoff/envdiff/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "envdiff";
  };
})
