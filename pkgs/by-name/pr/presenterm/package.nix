{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "presenterm";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "mfontanini";
    repo = "presenterm";
    rev = "v${version}";
    hash = "sha256-sXVMVU34gxZKGNye6hoyv07a7N7f6UbivA6thbSOeZA=";
  };

  cargoHash = "sha256-PsDaXMws/8hEvAZwClQ4okGuryg1iKg0IBr7Xp2QYBE=";

  meta = with lib; {
    description = "A terminal based slideshow tool";
    homepage = "https://github.com/mfontanini/presenterm";
    license = licenses.bsd2;
    maintainers = with maintainers; [ mikaelfangel ];
    mainProgram = "presenterm";
  };
}
