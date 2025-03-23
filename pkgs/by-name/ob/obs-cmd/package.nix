{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "obs-cmd";
  version = "0.18.2";

  src = fetchFromGitHub {
    owner = "grigio";
    repo = "obs-cmd";
    rev = "v${version}";
    hash = "sha256-plNLVBSTen11q945qtDBJaNTWKGICbuWokyvRzhu0Wg=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-ZKHm6N7y5FbDFiK2QfQ+9siexgzrdLpBs5Xikh1SRLo=";

  meta = with lib; {
    description = "Minimal CLI to control OBS Studio via obs-websocket";
    homepage = "https://github.com/grigio/obs-cmd";
    changelog = "https://github.com/grigio/obs-cmd/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    mainProgram = "obs-cmd";
  };
}
