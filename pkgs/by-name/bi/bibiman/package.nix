{
  fetchFromCodeberg,
  lib,
  nix-update-script,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "bibiman";
  version = "0.19.5";

  src = fetchFromCodeberg {
    owner = "lukeflo";
    repo = "bibiman";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mBd5egAcoj6+UTazSzVVma9oct5hns5BsCkhgcpPANs=";
  };

  cargoHash = "sha256-AvbJmo9S0rKZPDzbTsUxEpB7eQPTpl/ShYEu/ANA94I=";

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
})
