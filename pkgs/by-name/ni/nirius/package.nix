{
  lib,
  fetchFromSourcehut,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "nirius";
  version = "0.4.1";

  src = fetchFromSourcehut {
    owner = "~tsdh";
    repo = "nirius";
    rev = "nirius-${version}";
    hash = "sha256-w4ZNlCXtyRDGnQQFkxAIibc4TvQ8BSZsKIFGaNOrK94=";
  };

  cargoHash = "sha256-8Io3edeWvgb7LXEmXG2l2ESTLBeltHliyG8dD71j2K0=";

  meta = {
    description = "Utility commands for the niri wayland compositor";
    mainProgram = "nirius";
    homepage = "https://git.sr.ht/~tsdh/nirius";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ tylerjl ];
    platforms = lib.platforms.linux;
  };
}
