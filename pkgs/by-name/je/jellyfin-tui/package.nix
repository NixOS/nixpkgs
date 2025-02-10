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
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "dhonus";
    repo = "jellyfin-tui";
    tag = "v${version}";
    hash = "sha256-k8hN6MfY/agg5Janq4s65te7uOmfEpXXzogaS3jNAC8=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-Ca43CPjjUhNBclkJTt2xFWNRacEvRkKdHosnWSjfN2I=";

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
