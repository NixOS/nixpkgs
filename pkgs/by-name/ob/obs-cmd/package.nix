{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "obs-cmd";
  version = "0.17.6";

  src = fetchFromGitHub {
    owner = "grigio";
    repo = "obs-cmd";
    rev = "v${version}";
    hash = "sha256-bZ3N0wCTXyCv6iBQDlieMDFa80yNu1XrI4W5EaN5y/I=";
  };

  cargoHash = "sha256-gIJOkWlBD1rv6bKf++v/pyI8/awdnZBo/U/5PFnEcvg=";

  meta = with lib; {
    description = "Minimal CLI to control OBS Studio via obs-websocket";
    homepage = "https://github.com/grigio/obs-cmd";
    license = licenses.mit;
    maintainers = with maintainers; [ ianmjones ];
    mainProgram = "obs-cmd";
  };
}
