{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:
let
  version = "2.8.0";
in
rustPlatform.buildRustPackage {
  pname = "catppuccin-whiskers";
  inherit version;

  src = fetchFromGitHub {
    owner = "catppuccin";
    repo = "whiskers";
    tag = "v${version}";
    hash = "sha256-pmUaedOR+yaScdo8APMXlMBpHc9rUOkUSmayXtFn5yo=";
  };

  cargoHash = "sha256-SaakNE2dbpkh5EPHdd7/GBFLV5YSLxTY6CHkMoR61U0=";

  meta = {
    homepage = "https://github.com/catppuccin/whiskers";
    description = "Templating tool to simplify the creation of Catppuccin ports";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Name ];
    mainProgram = "whiskers";
  };
}
