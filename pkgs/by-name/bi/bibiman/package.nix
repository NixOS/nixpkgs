{
  fetchFromGitea,
  lib,
  nix-update-script,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage rec {
  pname = "bibiman";
  version = "0.14.1";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "lukeflo";
    repo = "bibiman";
    tag = "v${version}";
    hash = "sha256-ni984OrzqwWBmN7UwTRzhK/pjPziB6yrLTt2V8g8qeQ=";
  };

  cargoHash = "sha256-PX/0c0CH+MWhU/TStbB/CeQrF0uCzn7MhhHhAx29IYQ=";

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
