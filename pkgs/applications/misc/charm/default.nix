{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "charm";
  version = "0.12.3";

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = "charm";
    rev = "v${version}";
    sha256 = "sha256-FQNOU75mZqeXAVFOxTXri6bfkJZx4A/YhXMf8bFAKxs=";
  };

  vendorSha256 = "sha256-6Grg6/q4idhWk6slxV2GBblmOA5dclFh/PcGtPXUTd4=";

  ldflags = [ "-s" "-w" "-X=main.Version=${version}" ];

  meta = with lib; {
    description = "Manage your charm account on the CLI";
    homepage = "https://github.com/charmbracelet/charm";
    changelog = "https://github.com/charmbracelet/charm/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ penguwin ];
  };
}
