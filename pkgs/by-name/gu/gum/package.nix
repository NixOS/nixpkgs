{
  lib,
  stdenv,
  buildGoModule,
  installShellFiles,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "gum";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-DHIFU+dfZpeQo9kN9Krc1dhTf2HlnC7PEwTfN6RYmSU=";
  };

  vendorHash = "sha256-BcHwFj4nGmKcbVnLEVd9rK54DAyVNc2Dlt085N+HtFA=";

  nativeBuildInputs = [
    installShellFiles
  ];

  ldflags = [
    "-s"
    "-w"
    "-X=main.Version=${version}"
  ];

  postInstall =
    ''
      $out/bin/gum man > gum.1
      installManPage gum.1
    ''
    + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
      installShellCompletion --cmd gum \
        --bash <($out/bin/gum completion bash) \
        --fish <($out/bin/gum completion fish) \
        --zsh <($out/bin/gum completion zsh)
    '';

  meta = with lib; {
    description = "Tasty Bubble Gum for your shell";
    homepage = "https://github.com/charmbracelet/gum";
    changelog = "https://github.com/charmbracelet/gum/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ maaslalani ];
    mainProgram = "gum";
  };
}
