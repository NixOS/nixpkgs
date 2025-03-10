{
  fetchFromGitea,
  lib,
  nix-update-script,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage rec {
  pname = "bibiman";
  version = "0.11.0";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "lukeflo";
    repo = "bibiman";
    tag = "v${version}";
    hash = "sha256-g8C5yLtEHS/4Q312Rdse9FFymDXacIHqwg/ySpSt+NE=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-RWLKiYyUQUgAPPWTugp1G05X3B9SbknmpVLc7eSdn8U=";

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
