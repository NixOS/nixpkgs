{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "terraform-backend-git";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "plumber-cd";
    repo = "terraform-backend-git";
    rev = "v${version}";
    hash = "sha256-nRh2eIVVBdb8jFfgmPoOk4y0TDoCeng50TRA+nphn58=";
  };

  vendorHash = "sha256-Y/4UgG/2Vp+gxBnGrNpAgRNfPZWJXhVo8TVa/VfOYt0=";

  nativeBuildInputs = [
    installShellFiles
  ];

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/plumber-cd/terraform-backend-git/cmd.Version=${version}"
  ];

  postInstall = ''
    installShellCompletion --cmd terraform-backend-git \
      --bash <($out/bin/terraform-backend-git completion bash) \
      --fish <($out/bin/terraform-backend-git completion fish) \
      --zsh <($out/bin/terraform-backend-git completion zsh)
  '';

  meta = with lib; {
    description = "Terraform HTTP Backend implementation that uses Git repository as storage";
    homepage = "https://github.com/plumber-cd/terraform-backend-git";
    changelog = "https://github.com/plumber-cd/terraform-backend-git/blob/${src.rev}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ blaggacao ];
  };
}
