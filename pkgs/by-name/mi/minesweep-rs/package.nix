{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "minesweep-rs";
  version = "6.0.54";

  src = fetchFromGitHub {
    owner = "cpcloud";
    repo = "minesweep-rs";
    rev = "v${version}";
    hash = "sha256-FzMCqsPBcbblItRzfnY43glY4We9jk0eBxjG0SZnau8=";
  };

  cargoHash = "sha256-HO0eO6Ip508AIALS50exP2btLd3jUhM+giHQpMdsAVA=";

  meta = with lib; {
    description = "Sweep some mines for fun, and probably not for profit";
    homepage = "https://github.com/cpcloud/minesweep-rs";
    license = licenses.asl20;
    mainProgram = "minesweep";
    maintainers = with maintainers; [ aleksana ];
    platforms = platforms.all;
  };
}
