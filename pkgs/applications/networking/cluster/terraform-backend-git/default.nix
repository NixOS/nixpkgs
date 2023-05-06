{ lib
, buildGoModule
, fetchFromGitHub
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

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Terraform HTTP Backend implementation that uses Git repository as storage";
    homepage = "https://github.com/plumber-cd/terraform-backend-git";
    changelog = "https://github.com/plumber-cd/terraform-backend-git/blob/${src.rev}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ blaggacao ];
  };
}
