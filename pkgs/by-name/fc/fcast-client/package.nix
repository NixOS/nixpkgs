{
  lib,
  rustPlatform,
  fetchFromGitLab,
}:

rustPlatform.buildRustPackage rec {
  pname = "fcast-client";
  version = "0.1.0-unstable-2024-05-23";

  src = fetchFromGitLab {
    domain = "gitlab.futo.org";
    owner = "videostreaming";
    repo = "fcast";
    rev = "cc07f95d2315406fcacf67cb3abb98efff5df5d9";
    hash = "sha256-vsD4xgrC5KbnZT6hPX3fi3M/CH39LtoRfa6nYD0iFew=";
  };

  sourceRoot = "${src.name}/clients/terminal";
  cargoHash = "sha256-VVG7AbwbbgCANMcFYNAIF76MQr7Fkmq5HXPxL3MnEhI=";

  meta = {
    description = "FCast Client Terminal, a terminal open-source media streaming client";
    homepage = "https://fcast.org/";
    license = lib.licenses.gpl3;
    longDescription = ''
      FCast is a protocol designed for wireless streaming of audio and video
      content between devices. Unlike alternative protocols like Chromecast and
      AirPlay, FCast is an open source protocol that allows for custom receiver
      implementations, enabling third-party developers to create their own
      receiver devices or integrate the FCast protocol into their own apps.
    '';
    mainProgram = "fcast";
    maintainers = with lib.maintainers; [ drupol ];
    platforms = lib.platforms.linux;
  };
}
