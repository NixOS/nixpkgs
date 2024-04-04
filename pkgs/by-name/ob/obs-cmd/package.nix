{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "obs-cmd";
  version = "0.17.5";

  src = fetchFromGitHub {
    owner = "grigio";
    repo = "obs-cmd";
    rev = "v${version}";
    hash = "sha256-AphpIehFHZwcZ7vO5FV6PBZSO3y6oLhH/kQhJjr34VY=";
  };

  cargoHash = "sha256-s/nWJ/8JnZwmROFSd2y6btopk2Cxp0zkMdy7mxVxr6k=";

  meta = with lib; {
    description = "Minimal CLI to control OBS Studio via obs-websocket";
    homepage = "https://github.com/grigio/obs-cmd";
    license = licenses.mit;
    maintainers = with maintainers; [ ianmjones ];
    mainProgram = "obs-cmd";
  };
}
