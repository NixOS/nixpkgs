{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "changie";
  version = "1.22.0";

  src = fetchFromGitHub {
    owner = "miniscruff";
    repo = "changie";
    rev = "v${version}";
    hash = "sha256-tq29L9YlzhjbHkUfE0ZZhSrH+rcAwgYjcEAUjP/lHm8=";
  };

  vendorHash = "sha256-nAwBVa+UssbfFbcOWFcsWUllBTeW89xPcgS+ofXDPf0=";

  nativeBuildInputs = [
    installShellFiles
  ];

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${version}"
  ];

  postInstall = ''
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
      figsoda
      matthiasbeyer
    ];
  };
}
