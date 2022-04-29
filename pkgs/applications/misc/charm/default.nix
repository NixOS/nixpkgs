{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "charm";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = "charm";
    rev = "v${version}";
    sha256 = "sha256-98TUiFy4X7lMUostkgZikk6r6wzBPF0pqWthrS9nU+U=";
  };

  vendorSha256 = "sha256-enkt7BUAntbB75LR12NB0vW6z9dTPzk0bGdRrn3JHm4=";

  ldflags = [ "-s" "-w" "-X=main.Version=${version}" ];

  meta = with lib; {
    description = "Manage your charm account on the CLI";
    homepage = "https://github.com/charmbracelet/charm";
    license = licenses.mit;
    maintainers = with maintainers; [ penguwin ];
  };
}
