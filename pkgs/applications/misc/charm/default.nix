{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "charm";
  version = "0.12.5";

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = "charm";
    rev = "v${version}";
    sha256 = "sha256-lTjpvh0bl4Fk+d3mcDvVQY3Ef6UYE23qoS60nltVcsU=";
  };

  vendorSha256 = "sha256-TNxAtx+fT6CEpa2g/tNl9sCwt3kAmNq7G870TPt2MQ4=";

  ldflags = [ "-s" "-w" "-X=main.Version=${version}" ];

  meta = with lib; {
    description = "Manage your charm account on the CLI";
    homepage = "https://github.com/charmbracelet/charm";
    changelog = "https://github.com/charmbracelet/charm/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ penguwin ];
  };
}
