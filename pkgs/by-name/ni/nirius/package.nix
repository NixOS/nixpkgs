{
  lib,
  fetchFromSourcehut,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "nirius";
  version = "0.5.4";

  src = fetchFromSourcehut {
    owner = "~tsdh";
    repo = "nirius";
    rev = "nirius-${version}";
    hash = "sha256-UZUat/BmMIvkAphLaU5jaiRCrtsXvUXXGOgPrjgpPaU=";
  };

  cargoHash = "sha256-eLQf3cC95y4UdPI/gJWN4Fdwa3DqXT+QvIV+2w34ul0=";

  meta = {
    description = "Utility commands for the niri wayland compositor";
    mainProgram = "nirius";
    homepage = "https://git.sr.ht/~tsdh/nirius";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ tylerjl ];
    platforms = lib.platforms.linux;
  };
}
