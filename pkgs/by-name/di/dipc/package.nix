{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage {
  pname = "dipc";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "doprz";
    repo = "dipc";
    rev = "b111b8cb997e3337974f861f44a73b557fb3c294";
    hash = "sha256-qP7LRwNIM92p5xQeuvQ03kwBM/HnRH+BniiKeYoihKw=";
  };

  cargoHash = "sha256-F6EYnkquvTsw4C7rl28Y1h9i9ChGccwZGkYSVrsEhVk=";

  meta = {
    description = "Convert your favorite images and wallpapers with your favorite color palettes/themes";
    homepage = "https://github.com/doprz/dipc";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [
      doprz
      ByteSudoer
    ];
    mainProgram = "dipc";
  };
}
