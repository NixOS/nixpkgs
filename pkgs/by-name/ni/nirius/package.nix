{
  lib,
  fetchFromSourcehut,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nirius";
  version = "0.7.1";

  src = fetchFromSourcehut {
    owner = "~tsdh";
    repo = "nirius";
    rev = "nirius-${finalAttrs.version}";
    hash = "sha256-+OPJODiZs3+d3W8vnLCbza4axgIu6WBeC2j+JLN/Zgg=";
  };

  cargoHash = "sha256-lxyChCuo6ZtZ6Sd50xn2KyY7JTf3KCobZnI0AsM3CUE=";

  meta = {
    description = "Utility commands for the niri wayland compositor";
    mainProgram = "nirius";
    homepage = "https://git.sr.ht/~tsdh/nirius";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ tylerjl ];
    platforms = lib.platforms.linux;
  };
})
