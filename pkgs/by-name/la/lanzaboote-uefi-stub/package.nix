{
  callPackage,
  fetchFromGitHub,
  lib,
  nix-update-script,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "lanzaboote-uefi-stub";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "lanzaboote";
    tag = "v${finalAttrs.version}";
    hash = "sha256-sr4Kfp6yaXUeyKL6n0Y8/ElcR3momIRC20HFc+LF22s=";
  };

  sourceRoot = "${finalAttrs.src.name}/rust/uefi";
  cargoHash = "sha256-7s1K80YIuqeEw0jhkXOCOdBKEMN/2v/FWPk3X7SaBDE=";

  passthru = {
    updateScript = nix-update-script { };

    tests.is-uefi-executable = callPackage ./tests/is-uefi-executable.nix { };
  };

  strictDeps = true;
  __structuredAttrs = true;

  meta = {
    description = "Lanzaboote UEFI stub for UEFI Secure Boot enablement on NixOS systems";
    homepage = "https://github.com/nix-community/lanzaboote";
    license = lib.licenses.gpl3Only;
    mainProgram = "lanzaboote_stub.efi";
    maintainers = with lib.maintainers; [
      raitobezarius
      ThinkChaos
    ];
    platforms = [
      "x86_64-uefi"
    ];
  };
})
