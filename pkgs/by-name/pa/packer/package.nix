{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "packer";
  version = "1.13.0";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "packer";
    rev = "v${version}";
    hash = "sha256-MWVNDRtvH33fby17rj8Fdc/14NGuxWIRNG6B+onUK+M=";
  };

  vendorHash = "sha256-aXeYGyMn+lnsfcQMJXRt1uZsdi9np26sMna6Ch1swbg=";

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --zsh contrib/zsh-completion/_packer
  '';

  meta = with lib; {
    description = "Tool for creating identical machine images for multiple platforms from a single source configuration";
    homepage = "https://www.packer.io";
    license = licenses.bsl11;
    maintainers = with maintainers; [
      zimbatm
      ma27
      techknowlogick
      qjoly
    ];
    changelog = "https://github.com/hashicorp/packer/blob/v${version}/CHANGELOG.md";
  };
}
