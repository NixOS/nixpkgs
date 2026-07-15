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

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "jellyfin-tui";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "dhonus";
    repo = "jellyfin-tui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-su2zybyRc5Tyi7F+xX/YsWxqz8vLJdX3mAccqKqkRgo=";
  };

  cargoHash = "sha256-euTJMkTPAnPJCAGUWkmcME1w6nOBq0GSUTDFEhE5nIc=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    openssl
    mpv
  ];

  nativeInstallCheckInputs = [
    writableTmpDirAsHomeHook
    versionCheckHook
  ];
  versionCheckKeepEnvironment = [ "HOME" ];
  preInstallCheck = ''
    mkdir -p "$HOME/${
      if stdenv.buildPlatform.isDarwin then "Library/Application Support" else ".local/share"
    }"
  '';
  doInstallCheck = true;

  postInstall = lib.optionalString stdenv.hostPlatform.isLinux ''
    install -Dm644 src/extra/jellyfin-tui.desktop $out/share/applications/jellyfin-tui.desktop
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Jellyfin music streaming client for the terminal";
    mainProgram = "jellyfin-tui";
    homepage = "https://github.com/dhonus/jellyfin-tui";
    changelog = "https://github.com/dhonus/jellyfin-tui/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ GKHWB ];
  };
})
