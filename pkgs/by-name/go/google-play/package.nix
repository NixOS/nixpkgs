{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "google-play";
  version = "1.6.3";

  src = fetchFromGitHub {
    owner = "3052";
    repo = "google";
    rev = "v${version}";
    hash = "sha256-Wf7k76TXBr10FIclo/Ny8MLDDSNXu54JTDS0vfw4UXA=";
  };

  subPackages = [
    "internal/play"
    "internal/badging"
  ];

  vendorHash = "sha256-NVN5qoGXiL6lOPZejUhK55EuzF7R0KsIT+2oCzK+Qg0=";

  meta = with lib; {
    description = "CLI app to download APK from Google Play or send API requests";
    maintainers = with maintainers; [ ulysseszhan ];
    # https://polyformproject.org/licenses/noncommercial/1.0.0
    license = licenses.unfree;
    homepage = "https://github.com/3052/google";
    mainProgram = "play";
    platforms = platforms.unix;
  };
}
