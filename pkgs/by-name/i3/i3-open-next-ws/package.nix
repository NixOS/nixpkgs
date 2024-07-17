{
  lib,
  rustPlatform,
  fetchCrate,
}:
rustPlatform.buildRustPackage rec {
  pname = "i3-open-next-ws";
  version = "0.1.5";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-eYHCm8jEv6Ll6/h1kcYHNxWGnVWI41ZB96Jec9oZFsY=";
  };
  cargoHash = "sha256-9U0bYCbkvcZJOCd4jZog4bSJkP1ntmAFjWm7lJDdcuo=";

  meta = {
    description = "A workspace management utility for i3 and sway, that picks the first unused workspace automagically";
    homepage = "https://github.com/JohnDowson/i3-open-next-ws";
    license = lib.licenses.mit;
    mainProgram = "i3-open-next-ws";
    maintainers = with lib.maintainers; [ quantenzitrone ];
    platforms = lib.platforms.linux;
  };
}
