{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "changie";
  version = "1.23.0";

  src = fetchFromGitHub {
    owner = "miniscruff";
    repo = "changie";
    rev = "v${version}";
    hash = "sha256-eTGmF70xhecIo8JMKKxbApwQj7rg3LpyEzXFxsp92xU=";
  };

  vendorHash = "sha256-IJdocKlyIbuRnfWnPiyjluV74186YYnjmGXBaDuTxkY=";

  nativeBuildInputs = [
    installShellFiles
  ];

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${version}"
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
    changelog = "https://github.com/miniscruff/changie/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      matthiasbeyer
    ];
  };
}
