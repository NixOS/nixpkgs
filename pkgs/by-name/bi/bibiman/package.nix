{
  fetchFromCodeberg,
  lib,
  nix-update-script,
  rustPlatform,
  stdenv,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "bibiman";
  version = "0.15.0";

  src = fetchFromCodeberg {
    owner = "lukeflo";
    repo = "bibiman";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GAPlfHeo/g2QaRW3v9LatqYajJ2gE1ssK77yJPhOKuo=";
  };

  cargoHash = "sha256-aQ9h+L232dxZRPOQ+6b+vI3v/QdBR4//3HV8K9vwWV8=";

  nativeInstallCheckInputs = lib.optionals (
    # Error: Operation not permitted (os error 1)
    !stdenv.hostPlatform.isDarwin
  ) [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "TUI for fast and simple interacting with your BibLaTeX database";
    homepage = "https://codeberg.org/lukeflo/bibiman";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ clementpoiret ];
    mainProgram = "bibiman";
    platforms = with lib.platforms; linux ++ darwin;
  };
})
