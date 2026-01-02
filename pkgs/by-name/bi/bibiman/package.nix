{
  fetchFromGitea,
  lib,
  nix-update-script,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage rec {
  pname = "bibiman";
  version = "0.15.0";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "lukeflo";
    repo = "bibiman";
    tag = "v${version}";
    hash = "sha256-GAPlfHeo/g2QaRW3v9LatqYajJ2gE1ssK77yJPhOKuo=";
  };

  cargoHash = "sha256-aQ9h+L232dxZRPOQ+6b+vI3v/QdBR4//3HV8K9vwWV8=";

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
