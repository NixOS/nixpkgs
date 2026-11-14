{
  buildGo126Module,
  fetchFromGitHub,
  lib,
  nix-update-script,
  stdenvNoCC,
  installShellFiles,
}:

buildGo126Module (finalAttrs: {
  pname = "quien";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "retlehs";
    repo = "quien";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HTTogbcBa/dOIZAl1sNCqZODlFk50N+94jDxQrWQwb8=";
  };

  vendorHash = "sha256-7gP6eN+lF90kSltQMHkVTTanogEAtbLnENdZTF9f98c=";

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenvNoCC.buildPlatform.canExecute stdenvNoCC.hostPlatform) ''
    installShellCompletion --cmd quien \
      --bash <($out/bin/quien completion bash) \
      --fish <($out/bin/quien completion fish) \
      --zsh <($out/bin/quien completion zsh)
  '';

  passthru.updateScript = nix-update-script { };

  __structuredAttrs = true;
  strictDeps = true;

  meta = with lib; {
    description = "A better WHOIS lookup tool";
    homepage = "https://benword.com/quien-a-better-whois-lookup-tool";
    changelog = "https://github.com/retlehs/quien/releases/tag/v${finalAttrs.version}";
    license = licenses.mit;
    maintainers = with maintainers; [ myzel394 ];
    mainProgram = "quien";
    platforms = platforms.linux ++ platforms.darwin;
  };
})
