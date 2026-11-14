{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "hcloud";
  version = "1.70.2";

  src = fetchFromGitHub {
    owner = "hetznercloud";
    repo = "cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kDWd47j+4wCCKvQvxejcpJ93L94KRr4/xRIRXsT63AY=";
  };

  vendorHash = "sha256-T9+u5qbO76FUbNdkig2OlE/KXWlmHnKE0Go8AsCbypo=";

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
