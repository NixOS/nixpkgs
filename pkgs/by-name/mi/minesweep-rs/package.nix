{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "minesweep-rs";
  version = "6.0.54";

  src = fetchFromGitHub {
    owner = "cpcloud";
    repo = "minesweep-rs";
    rev = "v${finalAttrs.version}";
    hash = "sha256-FzMCqsPBcbblItRzfnY43glY4We9jk0eBxjG0SZnau8=";
  };

  cargoHash = "sha256-HO0eO6Ip508AIALS50exP2btLd3jUhM+giHQpMdsAVA=";

  meta = {
    description = "Sweep some mines for fun, and probably not for profit";
    homepage = "https://github.com/cpcloud/minesweep-rs";
    license = lib.licenses.asl20;
    mainProgram = "minesweep";
    maintainers = with lib.maintainers; [ aleksana ];
    platforms = lib.platforms.all;
  };
})
