{ lib, buildGoModule, installShellFiles, fetchFromGitHub }:

buildGoModule rec {
  pname = "gum";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-NgMEgSfHVLCEKZ3MmNV571ySMUD8wj+kq5EccGrxtZc=";
  };

  vendorHash = "sha256-fmc6nbS/Xmn/YRwToRH7EhP4SFRMf8hjZ/rLtaP/USo=";

  nativeBuildInputs = [
    installShellFiles
  ];

  ldflags = [ "-s" "-w" "-X=main.Version=${version}" ];

  postInstall = ''
    $out/bin/gum man > gum.1
    installManPage gum.1
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
