{
  lib,
  fetchFromGitHub,
  buildGoModule,
  nix-update-script,
}:

buildGoModule rec {
  pname = "google-play";
  version = "1.7.4";

  src = fetchFromGitHub {
    owner = "UlyssesZh";
    repo = "google-play";
    tag = "v${version}";
    hash = "sha256-Qv79fM59AQ+Y0OfWXKW1Jub07J5net3pP8ANm7CtB6A=";
  };

  subPackages = [
    "internal/play"
    "internal/badging"
  ];

  vendorHash = "sha256-+n08a22VEHjKUyk/XxTXBu9yYggSgIxCFx8PFtA2OCc=";

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
