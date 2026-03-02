{
  lib,
  fetchFromSourcehut,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nirius";
  version = "0.7.0";

  src = fetchFromSourcehut {
    owner = "~tsdh";
    repo = "nirius";
    rev = "nirius-${finalAttrs.version}";
    hash = "sha256-e/3FOlA29u214gs8Y4Tvk+XJUhT5Bn4GLrptbqrDRw8=";
  };

  cargoHash = "sha256-4tdPm4+ykEjGeYpQxR3M8Zh84VMDkkQXAaWlehunZ8c=";

  meta = {
    description = "Utility commands for the niri wayland compositor";
    mainProgram = "nirius";
    homepage = "https://git.sr.ht/~tsdh/nirius";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ tylerjl ];
    platforms = lib.platforms.linux;
  };
})
