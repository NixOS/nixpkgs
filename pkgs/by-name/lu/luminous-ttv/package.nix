{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "luminous-ttv";
  version = "0.5.11";

  src = fetchFromGitHub {
    owner = "AlyoshaVasilieva";
    repo = "luminous-ttv";
    rev = "v${version}";
    hash = "sha256-DlKoRP9ibJMrpX8YBWThYZdaVGCUsV4D+Gqme0J0cFg=";
  };

  cargoHash = "sha256-I3oZiAxhsFCxOTztegK6jjH/sJ4eJZNNFAoJfg/DALw=";

  meta = {
    description = "Rust server to retrieve and relay a playlist for Twitch livestreams/VODs";
    homepage = "https://github.com/AlyoshaVasilieva/luminous-ttv";
    downloadPage = "https://github.com/AlyoshaVasilieva/luminous-ttv/releases/latest";
    changelog = "https://github.com/AlyoshaVasilieva/luminous-ttv/releases/tag/v${version}";
    license = with lib.licenses; [
      gpl3Only
      mit
    ];
    mainProgram = "luminous-ttv";
    maintainers = with lib.maintainers; [ alex ];
  };
}
