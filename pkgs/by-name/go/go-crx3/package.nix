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
  pname = "go-crx3";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "mmadfox";
    repo = "go-crx3";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XNUOnm898GtCIojWR4tCHZNDHhh+DfJvvBvTDBI8Wzg=";
  };

  vendorHash = "sha256-LEIB/VZA3rqTeH9SesZ/jrfVddl6xtmoRWHP+RwGmCk=";

  ldflags = [
    "-s"
    "-w"
  ];

  checkFlags = [
    # requires network access
    "-skip=^TestDownloadFromWebStore(|Negative)$"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd crx3 \
      --bash <($out/bin/crx3 completion bash) \
      --fish <($out/bin/crx3 completion fish) \
      --zsh <($out/bin/crx3 completion zsh)
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/crx3";
  versionCheckProgramArg = "version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Chrome browser extension tools";
    homepage = "https://github.com/mmadfox/go-crx3";
    changelog = "https://github.com/mmadfox/go-crx3/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ defelo ];
    mainProgram = "crx3";
  };
})
