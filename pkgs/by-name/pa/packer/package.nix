{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "packer";
  version = "1.14.2";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "packer";
    rev = "v${version}";
    hash = "sha256-PR2wKpqU4pL5OurOR+ju9yil6cJF5WRXmVP0g9JF5KM=";
  };

  vendorHash = "sha256-LJklEYxNYwRQNdxoO1FUCD1kK38+eptGBff+3MHT44U=";

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
