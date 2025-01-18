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
    tag = "v${version}";
    hash = "sha256-OLEXy9MCrPQu1KWICsYhe/ayVqxkYIFwyJoJhgiNDz4=";
  };

  cargoHash = "sha256-5FvW+ioeDi0kofDswyQpUC21wbEZM8TAeUEUemnNfnA=";

  meta = with lib; {
    homepage = "https://github.com/catppuccin/whiskers";
    description = "A templating tool to simplify the creation of Catppuccin ports";
    license = licenses.mit;
    maintainers = with maintainers; [ Name ];
    mainProgram = "whiskers";
  };
}
