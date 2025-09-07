{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "pls";
  version = "0.0.1-beta.9";

  src = fetchFromGitHub {
    owner = "pls-rs";
    repo = "pls";
    tag = "v${version}";
    hash = "sha256-ofwdhGpqYlADDY2BLe0SkoHWqSeRNtQaXK61zWVFXzw=";
  };

  cargoHash = "sha256-P+4jRuakDUPaICJPsNJ6nXfhm09K/GC/VA9bsTXIMvc=";

  meta = {
    changelog = "https://github.com/pls-rs/pls/releases/tag/${src.tag}";
    description = "Prettier and powerful ls";
    homepage = "http://pls.cli.rs";
    license = lib.licenses.gpl3Plus;
    mainProgram = "pls";
    maintainers = with lib.maintainers; [ tomasajt ];
  };
}
