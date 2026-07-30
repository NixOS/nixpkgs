{
  lib,
  fetchFromSourcehut,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nirius";
  version = "0.8.0";

  src = fetchFromSourcehut {
    owner = "~tsdh";
    repo = "nirius";
    rev = "nirius-${finalAttrs.version}";
    hash = "sha256-hLrGdeRDhNC7xyG0IIQN1A+O8WzqIZqIRZ04fkLfANs=";
  };

  cargoHash = "sha256-3d/U5xsOPV5XzZuLNvkV4BYCfzrpFCol5p8Ras3eCn8=";

  meta = {
    description = "Utility commands for the niri wayland compositor";
    mainProgram = "nirius";
    homepage = "https://git.sr.ht/~tsdh/nirius";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ tylerjl ];
    platforms = lib.platforms.linux;
  };
})
