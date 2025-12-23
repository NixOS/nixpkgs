{
  lib,
  stdenv,
  fetchFromGitLab,
  buildGoModule,
  installShellFiles,
  nix-update-script,
}:
buildGoModule rec {
  pname = "optinix";
  version = "0.1.4";

  src = fetchFromGitLab {
    owner = "hmajid2301";
    repo = "optinix";
    tag = "v${version}";
    hash = "sha256-OuzLTygfJj1ILT0lAcBC28vU5YLuq0ErZHsLHoQNWBA=";
  };

  vendorHash = "sha256-gnxG4VqdZbGQyXc1dl3pU7yr3BbZPH17OLAB3dffcrk=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd optinix \
      --bash <($out/bin/optinix completion bash) \
      --fish <($out/bin/optinix completion fish) \
      --zsh <($out/bin/optinix completion zsh)
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tool for searching options in Nix";
    homepage = "https://gitlab.com/hmajid2301/optinix";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      hmajid2301
      brianmcgillion
    ];
    changelog = "https://gitlab.com/hmajid2301/optinix/-/releases/v${version}";
    mainProgram = "optinix";
  };
}
