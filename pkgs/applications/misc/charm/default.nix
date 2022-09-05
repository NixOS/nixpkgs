{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "charm";
  version = "0.12.4";

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = "charm";
    rev = "v${version}";
    sha256 = "sha256-1uxgiVJGdTE8R0gEQ515zxoKXSs5lTGAURNlgJYMuMI=";
  };

  vendorSha256 = "sha256-ouqA4Rg03M9dAUu2Uxmvez7LJTcrqYvqPNVQQmqwoFQ=";

  ldflags = [ "-s" "-w" "-X=main.Version=${version}" ];

  meta = with lib; {
    description = "Manage your charm account on the CLI";
    homepage = "https://github.com/charmbracelet/charm";
    changelog = "https://github.com/charmbracelet/charm/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ penguwin ];
  };
}
