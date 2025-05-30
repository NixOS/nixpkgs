{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "hcloud";
  version = "1.51.0";

  src = fetchFromGitHub {
    owner = "hetznercloud";
    repo = "cli";
    tag = "v${version}";
    hash = "sha256-wRz+zWUeKAbk6EmYjm7A4ks7ZhXXhpipts6XZZthsI0=";
  };

  vendorHash = "sha256-axVG4KOxDy7+brwui2iPLutFLJ8L7LAQmeDcoFCv7uA=";

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

  meta = with lib; {
    changelog = "https://github.com/hetznercloud/cli/releases/tag/v${version}";
    description = "Command-line interface for Hetzner Cloud, a provider for cloud virtual private servers";
    mainProgram = "hcloud";
    homepage = "https://github.com/hetznercloud/cli";
    license = licenses.mit;
    maintainers = with maintainers; [
      zauberpony
      techknowlogick
    ];
  };
}
