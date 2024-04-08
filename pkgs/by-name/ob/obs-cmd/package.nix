{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "obs-cmd";
  version = "0.17.4";

  src = fetchFromGitHub {
    owner = "grigio";
    repo = "obs-cmd";
    rev = "v${version}";
    hash = "sha256-HCvIMIQZKzIkpYL9F9oM4xiE/gOeI+7dMj9QmhetHm4=";
  };

  cargoHash = "sha256-AQRjZH3WhZXU6NhDSCv4/HWz5un1nFtuzWPYSJA9XaE=";

  meta = with lib; {
    description = "Minimal CLI to control OBS Studio via obs-websocket";
    homepage = "https://github.com/grigio/obs-cmd";
    license = licenses.mit;
    maintainers = with maintainers; [ ianmjones ];
    mainProgram = "obs-cmd";
  };
}
