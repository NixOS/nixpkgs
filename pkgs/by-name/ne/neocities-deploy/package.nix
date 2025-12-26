{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage rec {
  pname = "neocities-deploy";
  version = "0.1.21";
  src = fetchFromGitHub {
    owner = "kugland";
    repo = "neocities-deploy";
    rev = "v${version}";
    hash = "sha256-ZOiHFK3CrDvCNoH5LoB7EUmjF9M6syYvqthpWm9uoCE=";
  };
  cargoHash = "sha256-CpUC+u+3+2EdnCpOfm+sYIiVY/ftfcHZ6zH6jqdF9P8=";
  doCheck = false; # This package's tests are impure
  meta = with lib; {
    description = "A command-line tool for deploying your Neocities site";
    homepage = "https://github.com/kugland/neocities-deploy";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ kugland ];
    mainProgram = "neocities-deploy";
    platforms = platforms.all;
  };
}
