{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "packer";
  version = "1.15.1";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "packer";
    rev = "v${version}";
    hash = "sha256-16nHjD2begkWnqy4g2pN8IX//BxRd9DA/TJ6sgKJi5M=";
  };

  vendorHash = "sha256-GOEdKMu41QjSl5iR07rXetq4YIdJ/Bf0zD32D5yayxc=";

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --zsh contrib/zsh-completion/_packer
  '';

  meta = {
    description = "Tool for creating identical machine images for multiple platforms from a single source configuration";
    homepage = "https://www.packer.io";
    license = lib.licenses.bsl11;
    maintainers = with lib.maintainers; [
      zimbatm
      ma27
      techknowlogick
      qjoly
    ];
    changelog = "https://github.com/hashicorp/packer/blob/v${version}/CHANGELOG.md";
  };
}
