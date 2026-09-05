{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  buildPackages,
  installShellFiles,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "cdebug";
  version = "0.0.19";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "iximiuz";
    repo = "cdebug";
    tag = "v${finalAttrs.version}";
    hash = "sha256-F2Bsn2dH49Jn72ddYHbCv4FHSF+coXwHTe5x1ITqUTU=";
  };

  vendorHash = "sha256-cpjpwL9w3PRcIoYYdfHLELMNRS9HjemMgvzWJWkb/7g=";

  # ./ci is a separate Go module holding the Dagger CI pipeline
  subPackages = [ "." ];

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${finalAttrs.version}"
  ];

  # The only tests are end-to-end tests requiring a running Docker,
  # containerd, or Kubernetes instance.
  doCheck = false;

  postInstall =
    let
      exe =
        if stdenv.buildPlatform.canExecute stdenv.hostPlatform then
          "$out/bin/cdebug"
        else
          lib.getExe buildPackages.cdebug;
    in
    ''
      installShellCompletion --cmd cdebug \
        --bash <(${exe} completion bash) \
        --fish <(${exe} completion fish) \
        --zsh <(${exe} completion zsh)
    '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Swiss army knife of container debugging";
    homepage = "https://github.com/iximiuz/cdebug";
    changelog = "https://github.com/iximiuz/cdebug/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ northbymidwest ];
    mainProgram = "cdebug";
  };
})
