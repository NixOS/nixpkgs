{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "changie";
  version = "1.25.0";

  src = fetchFromGitHub {
    owner = "miniscruff";
    repo = "changie";
    rev = "v${finalAttrs.version}";
    hash = "sha256-u32vA7rAuXMaxToDPeB/QpNf6Qo0PFf8hkTFQhY89TA=";
  };

  vendorHash = "sha256-VoiGg0K89S98j2q68U0oYENgAYjynl3EeFC47l3Hq9Q=";

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
