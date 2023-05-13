{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "glow";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = "glow";
    rev = "v${version}";
    sha256 = "sha256-12UziCf3BO1z+W02slNCCvXhIkvZuVgXk++BdHG3gDI=";
  };

  vendorHash = "sha256-AnItZMWCvFg2ZBxschKaCKYeRZjoedTqbZKMS1uaYUE=";

  doCheck = false;

  ldflags = [ "-s" "-w" "-X=main.Version=${version}" ];

  meta = with lib; {
    description = "Render markdown on the CLI, with pizzazz!";
    homepage = "https://github.com/charmbracelet/glow";
    changelog = "https://github.com/charmbracelet/glow/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ Br1ght0ne penguwin ];
  };
}
