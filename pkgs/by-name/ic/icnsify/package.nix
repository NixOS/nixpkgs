{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
let
  version = "0.1.1";
in
rustPlatform.buildRustPackage {
  pname = "icnsify";
  inherit version;

  src = fetchFromGitHub {
    owner = "uncenter";
    repo = "icnsify";
    rev = "v${version}";
    hash = "sha256-9BZTY175GaaNCq8gcfw4Wl5vzphy4k+hNhW5m6z3adw=";
  };

  cargoHash = "sha256-SutIlmGVdXb+B0JE7UDG5cKWUdpFlnXBQjBntmUNQVA=";

  meta = {
    description = "Convert PNGs to .icns";
    homepage = "https://github.com/uncenter/icnsify";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ uncenter ];
    mainProgram = "icnsify";
  };
}
