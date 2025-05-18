{
  fetchFromGitea,
  lib,
  nix-update-script,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage rec {
  pname = "bibiman";
  version = "0.11.6";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "lukeflo";
    repo = "bibiman";
    tag = "v${version}";
    hash = "sha256-nyONqQmS8MvgMrq6XIuMjc8FkP9wKQu+EVnQUcSAjEo=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-fdUCrf6gdZZtrL93GQMnA+4ZJ8qkjsBKJJN5u4VKE1w=";

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
