{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "luminous-ttv";
  version = "0.5.13";

  src = fetchFromGitHub {
    owner = "AlyoshaVasilieva";
    repo = "luminous-ttv";
    rev = "v${finalAttrs.version}";
    hash = "sha256-kwhaobSXE/i1WUDfBaLVEsZVSORxRU6Imdul+T043RU=";
  };

  cargoHash = "sha256-EIvPQNPWH2IH2Ll5tSsS3cj592jxWljXc1z4LGGZC6I=";

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
