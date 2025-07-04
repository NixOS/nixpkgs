{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "packer";
  version = "1.13.1";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "packer";
    rev = "v${version}";
    hash = "sha256-8DKMRiqv0XasLvFHGscpet51ZLVJjWjAYP8bLgVRIyQ=";
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
