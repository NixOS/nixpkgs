{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nixos-wizard";
  version = "0.4.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "km-clay";
    repo = "nixos-wizard";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QhdZjyiy9zV0Sz7nkBHTlu3nmDfmgdKEc0ulxLFmfoU=";
  };

  cargoHash = "sha256-RgHobA+qw/2wC9MTGIXVe9E/UqK7rqnHTCDPHqV3jb0=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "TUI installer for NixOS";
    homepage = "https://github.com/km-clay/nixos-wizard";
    changelog = "https://github.com/km-clay/nixos-wizard/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Br1ght0ne ];
    mainProgram = "nixos-wizard";
  };
})
