{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "luminous-ttv";
<<<<<<< HEAD
  version = "0.5.12";
=======
  version = "0.5.11";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "AlyoshaVasilieva";
    repo = "luminous-ttv";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-uTfbFSK7vwt+zLWN5EdudPnmJvg5F4U8Zx6CLV8fePc=";
  };

  cargoHash = "sha256-4Tv4FO2PSH9G9u5L3Y/LknslwbWpzURSv/Yq4ICzgpo=";
=======
    hash = "sha256-DlKoRP9ibJMrpX8YBWThYZdaVGCUsV4D+Gqme0J0cFg=";
  };

  cargoHash = "sha256-I3oZiAxhsFCxOTztegK6jjH/sJ4eJZNNFAoJfg/DALw=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
