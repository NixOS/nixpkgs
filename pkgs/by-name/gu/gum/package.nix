{
  lib,
  stdenv,
  buildGoModule,
  installShellFiles,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "gum";
  version = "0.14.5";

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-moKirTXziVo6ESOsnTUmPkcdBYL/VHaG226+UfM0xAk=";
  };

  vendorHash = "sha256-wjM2ld4go7OQu6XqsSGurjN09Fd5t9FNLvIzgrZEZ1k=";

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
