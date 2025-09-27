{
  lib,
  fetchFromSourcehut,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "nirius";
  version = "0.4.3";

  src = fetchFromSourcehut {
    owner = "~tsdh";
    repo = "nirius";
    rev = "nirius-${version}";
    hash = "sha256-JAoKuM+A9AO1erhpWIYKq8lWjRAYjDKqxf1r/Fu2IAM=";
  };

  cargoHash = "sha256-btau5IVJ4PWK65eU1F7cmUzF4MOj8FEc4p8KhHg03QQ=";

  meta = {
    description = "Utility commands for the niri wayland compositor";
    mainProgram = "nirius";
    homepage = "https://git.sr.ht/~tsdh/nirius";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ tylerjl ];
    platforms = lib.platforms.linux;
  };
}
