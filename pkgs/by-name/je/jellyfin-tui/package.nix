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
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "dhonus";
    repo = "jellyfin-tui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-uuY2kzF/ZJhaAHU4ZHKZsl6kl7kUjsadvB/5jP1WJwM=";
  };

  cargoHash = "sha256-lmBk5UFb+NWjIaHvTeIzvQNdWeo5BOtmuajD3XpdBT4=";

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
