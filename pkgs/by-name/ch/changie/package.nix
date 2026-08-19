{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "changie";
  version = "1.25.2";

  src = fetchFromGitHub {
    owner = "miniscruff";
    repo = "changie";
    rev = "v${finalAttrs.version}";
    hash = "sha256-fWPN3oEhJEosb47QUPpi9KtXzTORFVWq/W241L+tnyQ=";
  };

  vendorHash = "sha256-+N/h5kNEiSFe1fnzuk/oqf8g0eND4SgHCN/HM9oOgoE=";

  nativeBuildInputs = [
    installShellFiles
  ];

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${finalAttrs.version}"
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd changie \
      --bash <($out/bin/changie completion bash) \
      --fish <($out/bin/changie completion fish) \
      --zsh <($out/bin/changie completion zsh)
  '';

  meta = {
    description = "Automated changelog tool for preparing releases with lots of customization options";
    mainProgram = "changie";
    homepage = "https://changie.dev";
    changelog = "https://github.com/miniscruff/changie/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      matthiasbeyer
    ];
  };
})
