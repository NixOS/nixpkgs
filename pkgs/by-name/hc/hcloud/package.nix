{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "hcloud";
  version = "1.54.0";

  src = fetchFromGitHub {
    owner = "hetznercloud";
    repo = "cli";
    tag = "v${version}";
    hash = "sha256-PpCEdhEjfd7d8DdU2ABAjL8O98cLR20xWwhcESJK4uI=";
  };

  vendorHash = "sha256-tJwd/qLs0QvnjKi0B2NBTosGt7qCzJCHxZ5LYJB4vjA=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/hetznercloud/cli/internal/version.Version=${version}"
  ];

  subPackages = [ "cmd/hcloud" ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    for shell in bash fish zsh; do
      $out/bin/hcloud completion $shell > hcloud.$shell
      installShellCompletion hcloud.$shell
    done
  '';

  meta = {
    changelog = "https://github.com/hetznercloud/cli/releases/tag/v${version}";
    description = "Command-line interface for Hetzner Cloud, a provider for cloud virtual private servers";
    mainProgram = "hcloud";
    homepage = "https://github.com/hetznercloud/cli";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      zauberpony
      techknowlogick
    ];
  };
}
