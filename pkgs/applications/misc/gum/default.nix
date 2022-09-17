{ lib, buildGoModule, installShellFiles, fetchFromGitHub }:

buildGoModule rec {
  pname = "gum";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-pEULArQDwKZzpD0GVH21L1v9xVZiBz91kL/jPJjJav4=";
  };

  vendorSha256 = "sha256-vvNoO5eABGVwvAzK33uPelmo3BKxfqiYgEXZI7kgeSo=";

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
  };
}
