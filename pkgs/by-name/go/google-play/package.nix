{
  lib,
  fetchFromGitHub,
  buildGoModule,
  nix-update-script,
}:

buildGoModule rec {
  pname = "google-play";
  version = "1.7.5";

  src = fetchFromGitHub {
    owner = "UlyssesZh";
    repo = "google-play";
    tag = "v${version}";
    hash = "sha256-CmNBE3SJhDyY77mjC56pl0aiyt4ZW6pEYTtOK3FXGhE=";
  };

  subPackages = [
    "internal/play"
    "internal/badging"
  ];

  vendorHash = "sha256-q0p9+74qUSY2AAnagtM6d6PPEhM1HHF019QWxTemiIo=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CLI app to download APK from Google Play or send API requests";
    maintainers = with lib.maintainers; [ ulysseszhan ];
    # https://polyformproject.org/licenses/noncommercial/1.0.0
    license = lib.licenses.unfree;
    homepage = "https://github.com/UlyssesZh/google-play";
    mainProgram = "play";
    platforms = lib.platforms.unix;
  };
}
