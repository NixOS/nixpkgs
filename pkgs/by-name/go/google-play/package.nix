{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "google-play";
  version = "1.5.8";

  src = fetchFromGitHub {
    owner = "3052";
    repo = "google";
    rev = "v${version}";
    hash = "sha256-viAqy/vFbkzW45oCUd3kvkR/8BzPYe/XdPJEpeSmcY0=";
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
