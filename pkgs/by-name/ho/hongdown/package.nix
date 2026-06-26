{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "hongdown";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "dahlia";
    repo = "hongdown";
    tag = finalAttrs.version;
    hash = "sha256-/dEUf74+s0oQyEbTEjBDx047NygfgL/FXCBj9LuasSM=";
  };
  cargoHash = "sha256-MIzzU/Q/pk9JObGPAQCCfKaUfvYW6YWVjwaGEUXvwXo=";
  meta = {
    description = "Markdown formatter that enforces Hong Minhee's Markdown style conventions";
    mainProgram = "hongdown";
    homepage = "https://github.com/dahlia/hongdown";
    changelog = "https://github.com/dahlia/hongdown/blob/main/CHANGES.md";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ wellmannmathis ];
  };
})
