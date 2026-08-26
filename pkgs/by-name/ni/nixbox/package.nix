{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nixbox";
  version = "0.2.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-GrcVSok45XEv2JQikwoD/hJUW0pNuPW/DwxsacqKRYE=";
  };

  cargoHash = "sha256-Ez40fonsSpXCddKAl3l24psmFJYXzp4BLkOJ8e656Vw=";

  __structuredAttrs = true;

  meta = with lib; {
    description = "TUI package manager for NixOS that wires selections into your flake + home-manager config";
    homepage = "https://github.com/SINGH-RAJVEER/nix-box";
    license = licenses.asl20;
    maintainers = with maintainers; [ rajveer ];
    mainProgram = "nixbox";
    platforms = platforms.linux;
  meta = {
    description = "TUI package manager for NixOS that wires selections into your flake + home-manager config";
    homepage = "https://github.com/SINGH-RAJVEER/nix-box";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ rajveer ];
    mainProgram = "nixbox";
    platforms = lib.platforms.linux;
  };
}
