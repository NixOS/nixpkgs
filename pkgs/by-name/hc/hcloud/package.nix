{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "hcloud";
<<<<<<< HEAD
  version = "1.58.0";
=======
  version = "1.57.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "hetznercloud";
    repo = "cli";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-jK5672g27qI4qHHhejrBP0W2YTo8vnUwnS9f50Yq4BI=";
  };

  vendorHash = "sha256-xAXL3ADmH20vH/nnFJdjWlc2WkiC92+SSRP4UKrWoGo=";
=======
    hash = "sha256-9mXgwBXqSk4WOSOg7JnopPZj1alokwbOUsbCErUHrsU=";
  };

  vendorHash = "sha256-tjSiSIKaMwOHTDo7AxYi1ziE/2nVdy+xm3UwKAhyb0E=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
