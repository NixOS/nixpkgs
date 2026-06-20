{
  lib,
  fetchFromSourcehut,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nirius";
  version = "0.7.2";

  src = fetchFromSourcehut {
    owner = "~tsdh";
    repo = "nirius";
    rev = "nirius-${finalAttrs.version}";
    hash = "sha256-H6geI5RkM0SXJyqXNai9vyc0cdTq2hHGpee8Tx2XDIU=";
  };

  cargoHash = "sha256-qsY0OXsCn6g/vIBkHtkG2Dvv2RjiOrhT1O8AvzyBiV0=";

  meta = {
    description = "Utility commands for the niri wayland compositor";
    mainProgram = "nirius";
    homepage = "https://git.sr.ht/~tsdh/nirius";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ tylerjl ];
    platforms = lib.platforms.linux;
  };
})
