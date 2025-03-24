{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "go-crx3";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "mmadfox";
    repo = "go-crx3";
    tag = "v${finalAttrs.version}";
    hash = "sha256-J3v3/Rz6rPTJnIEahWvJO6KGIC6idqJ/39wPC4zApbE=";
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

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    $out/bin/crx3 --help >/dev/null

    runHook postInstallCheck
  '';

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
