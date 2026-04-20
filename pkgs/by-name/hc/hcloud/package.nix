{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "hcloud";
  version = "1.62.2";

  src = fetchFromGitHub {
    owner = "hetznercloud";
    repo = "cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OGz/f68DDYJ7s3HFjDdQPtD86929gxRehSPs9cCkPBk=";
  };

  vendorHash = "sha256-8JvqGCVFE2dSlpMzwYXKMvg3nw/wt8GxL7sM0bS6ZgM=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/hetznercloud/cli/internal/version.Version=${finalAttrs.version}"
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
    changelog = "https://github.com/hetznercloud/cli/releases/tag/v${finalAttrs.version}";
    description = "Command-line interface for Hetzner Cloud, a provider for cloud virtual private servers";
    mainProgram = "hcloud";
    homepage = "https://github.com/hetznercloud/cli";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      zauberpony
      techknowlogick
    ];
  };
})
