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

  cargoHash = "sha256-CVg7kcOTRa8KfDwiJHQhTPQfK6g3jOMa4h/BCUo3ehw=";

  meta = {
    homepage = "https://github.com/catppuccin/whiskers";
    description = "Templating tool to simplify the creation of Catppuccin ports";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Name ];
    mainProgram = "whiskers";
  };
}
