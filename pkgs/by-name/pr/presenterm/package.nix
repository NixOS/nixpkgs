{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "presenterm";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "mfontanini";
    repo = "presenterm";
    rev = version;
    hash = "sha256-mNWnUUezKIffh5gMgMMdvApNZZTxxB8XrL0jFLyBxuk=";
  };

  cargoHash = "sha256-JLPJLhWN/yXpPIHa+FJ2aQ/GDUFKtZ7t+/8rvR8WNKM=";

  meta = with lib; {
    description = "A terminal based slideshow tool";
    homepage = "https://github.com/mfontanini/presenterm";
    license = licenses.bsd2;
    maintainers = with maintainers; [ mikaelfangel ];
    mainProgram = "presenterm";
  };
}
