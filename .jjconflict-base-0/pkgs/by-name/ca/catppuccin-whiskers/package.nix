{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:
let
  version = "2.5.1";
in
rustPlatform.buildRustPackage {
  pname = "catppuccin-whiskers";
  inherit version;

  src = fetchFromGitHub {
    owner = "catppuccin";
    repo = "whiskers";
    rev = "refs/tags/v${version}";
    hash = "sha256-OLEXy9MCrPQu1KWICsYhe/ayVqxkYIFwyJoJhgiNDz4=";
  };

  cargoHash = "sha256-5FvW+ioeDi0kofDswyQpUC21wbEZM8TAeUEUemnNfnA=";

  meta = {
    homepage = "https://github.com/catppuccin/whiskers";
    description = "A templating tool to simplify the creation of Catppuccin ports";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Name ];
    mainProgram = "whiskers";
  };
}
