{ lib, buildGoModule, fetchFromGitHub, git }:

buildGoModule rec {
  pname = "conform";
  version = "0.1.0-alpha.25";

  src = fetchFromGitHub {
    owner = "siderolabs";
    repo = "conform";
    rev = "v${version}";
    sha256 = "sha256-WgWgigpqPoEBY4tLjbzK02WFwrCWPGQWJ5eakLv5IWw=";
  };

  vendorSha256 = "sha256-Oigt7tAK4jhBQtfG1wdLHqi11NWu6uJn5fmuqTmR76E=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/talos-systems/conform/internal/version.Tag=v${version}"
  ];

  checkInputs = [ git ];

  meta = with lib; {
    description = "Policy enforcement for your pipelines";
    homepage = "https://github.com/siderolabs/conform";
    license = licenses.mpl20;
    maintainers = with maintainers; [ jmgilman jk ];
  };
}
