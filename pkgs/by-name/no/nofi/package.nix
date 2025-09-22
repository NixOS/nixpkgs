{
  lib,
  rustPlatform,
  fetchFromGitHub,
  dbus,
  pkg-config,
}:

rustPlatform.buildRustPackage rec {
  pname = "nofi";
  version = "0.2.4";

  src = fetchFromGitHub {
    owner = "ellsclytn";
    repo = "nofi";
    rev = "v${version}";
    hash = "sha256-hQYIcyNCxb8qVpseNsmjyPxlwbMxDpXeZ+H1vpv62rQ=";
  };

  cargoHash = "sha256-dWqMwS0TgspZqlpi8hhwtA7sbqGunw0FIqjJXOTiFKA=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ dbus ];

  meta = {
    description = "Interruption-free notification system for Linux";
    homepage = "https://github.com/ellsclytn/nofi/";
    changelog = "https://github.com/ellsclytn/nofi/raw/v${version}/CHANGELOG.md";
    license = [
      lib.licenses.asl20 # or
      lib.licenses.mit
    ];
    mainProgram = "nofi";
    maintainers = [ lib.maintainers.magnetophon ];
  };
}
