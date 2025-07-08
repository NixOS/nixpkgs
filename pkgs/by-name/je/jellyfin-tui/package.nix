{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
  mpv,
  nix-update-script,
  writableTmpDirAsHomeHook,
  versionCheckHook,
}:

rustPlatform.buildRustPackage rec {
  pname = "jellyfin-tui";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "dhonus";
    repo = "jellyfin-tui";
    tag = "v${version}";
    hash = "sha256-ECMZ8sWzX/aZK0N8zGz5dMCndVVxwkZW/qSvmHu+87Q=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-rOKgaEDfOZfVuwMnp81Kd/mq0o0SkQD2lVNLubUq1HQ=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    openssl
    mpv
  ];

  nativeInstallCheckInputs = [
    writableTmpDirAsHomeHook
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
  versionCheckKeepEnvironment = [ "HOME" ];
  preInstallCheck = ''
    mkdir -p "$HOME/${
      if stdenv.buildPlatform.isDarwin then "Library/Application Support" else ".local/share"
    }"
  '';
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
