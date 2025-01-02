{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "powerline-go";
  version = "1.25";

  src = fetchFromGitHub {
    owner = "justjanne";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-DLw/6jnJo0IAh0/Y21mfCLP4GgTFlUGvuwyWJwhzYFU=";
  };

  vendorHash = "sha256-W7Lf9s689oJy4U5sQlkLt3INJwtvzU2pot3EFimp7Jw=";

  meta = with lib; {
    description = "Powerline like prompt for Bash, ZSH and Fish";
    homepage = "https://github.com/justjanne/powerline-go";
    changelog = "https://github.com/justjanne/powerline-go/releases/tag/v${version}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ sifmelcara ];
    mainProgram = "powerline-go";
  };
}
