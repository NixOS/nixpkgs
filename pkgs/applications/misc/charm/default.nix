{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "charm";
  version = "0.10.2";

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = "charm";
    rev = "v${version}";
    sha256 = "sha256-kyfyRq/5QWMoiMooEpLv7UkehGxFlrfGEq9jA3OHiIs=";
  };

  vendorSha256 = "sha256-LB5fwySDOH+kOYYdGdtLAvETmI6fFP2QT6l2eAS3Ijg=";

  doCheck = false;

  ldflags = [ "-s" "-w" "-X=main.Version=${version}" ];

  meta = with lib; {
    description = "Manage your charm account on the CLI";
    homepage = "https://github.com/charmbracelet/charm";
    license = licenses.mit;
    maintainers = with maintainers; [ penguwin ];
  };
}
