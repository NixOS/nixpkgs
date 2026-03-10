{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "luminous-ttv";
  version = "0.5.12";

  src = fetchFromGitHub {
    owner = "AlyoshaVasilieva";
    repo = "luminous-ttv";
    rev = "v${finalAttrs.version}";
    hash = "sha256-uTfbFSK7vwt+zLWN5EdudPnmJvg5F4U8Zx6CLV8fePc=";
  };

  cargoHash = "sha256-4Tv4FO2PSH9G9u5L3Y/LknslwbWpzURSv/Yq4ICzgpo=";

  meta = {
    description = "Rust server to retrieve and relay a playlist for Twitch livestreams/VODs";
    homepage = "https://github.com/AlyoshaVasilieva/luminous-ttv";
    downloadPage = "https://github.com/AlyoshaVasilieva/luminous-ttv/releases/latest";
    changelog = "https://github.com/AlyoshaVasilieva/luminous-ttv/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [
      gpl3Only
      mit
    ];
    mainProgram = "luminous-ttv";
    maintainers = with lib.maintainers; [ alex ];
  };
})
