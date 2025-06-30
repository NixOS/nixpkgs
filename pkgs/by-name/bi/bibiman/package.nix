{
  fetchFromGitea,
  lib,
  nix-update-script,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage rec {
  pname = "bibiman";
  version = "0.12.4";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "lukeflo";
    repo = "bibiman";
    tag = "v${version}";
    hash = "sha256-6duqLBPm6GlBHm3Kr4foHF1MKodYOYKKDITk/BiX6mA=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-tbgzjTsK88+G4Wxex4Tl0K5Ii99tPNud3UEDzAHaI0M=";

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "TUI for fast and simple interacting with your BibLaTeX database";
    homepage = "https://codeberg.org/lukeflo/bibiman";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ clementpoiret ];
    mainProgram = "bibiman";
    platforms = lib.platforms.linux;
  };
}
