{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "google-play";
  version = "2024-10-18";

  src = fetchFromGitHub {
    owner = "3052";
    repo = "google";
    rev = "b30b2a5efa3c14440ca43d59f8c0ada548ede30b";
    hash = "sha256-nVwUblDA0ppvg6IapCPomIb4g2g4FH6myPZ2r/TU7KQ=";
  };

  subPackages = [
    "internal/play"
    "internal/badging"
  ];

  vendorHash = "sha256-C04/LcTcXaVzl74cTJBIZT+1mBw+cmOT8TllWIm4Jt4=";

  meta = {
    description = "CLI app to download APK from Google Play or send API requests";
    maintainers = with lib.maintainers; [ ulysseszhan ];
    # https://polyformproject.org/licenses/noncommercial/1.0.0
    license = lib.licenses.unfree;
    homepage = "https://github.com/3052/google";
    mainProgram = "play";
    platforms = lib.platforms.unix;
  };
}
