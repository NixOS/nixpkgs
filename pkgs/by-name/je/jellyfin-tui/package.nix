{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
  mpv,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage rec {
  pname = "jellyfin-tui";
  version = "1.1.3";

  src = fetchFromGitHub {
    owner = "dhonus";
    repo = "jellyfin-tui";
    tag = "v${version}";
    hash = "sha256-zTvycwmVTUK7qP9PacHeREhVk0UJ4fos0Z2OGdWI0Mg=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-nBtz05c4W5qIiOPfQ+PGy0LVvvXXCFmdfjk2VjBMvnE=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    openssl
    mpv
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Jellyfin music streaming client for the terminal";
    mainProgram = "jellyfin-tui";
    homepage = "https://github.com/dhonus/jellyfin-tui";
    changelog = "https://github.com/dhonus/jellyfin-tui/releases/tag/v${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ GKHWB ];
  };
}
