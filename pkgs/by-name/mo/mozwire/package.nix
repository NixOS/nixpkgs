{
  rustPlatform,
  lib,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "MozWire";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "NilsIrl";
    repo = "MozWire";
    rev = "v${finalAttrs.version}";
    hash = "sha256-2i8C1XgfI3MXnwXZzY6n8tIcw45G9h3vZqRlFaVoLH0=";
  };

  cargoHash = "sha256-UEo/CSRg1hS/BIEQTEgqfwwz1LAMDdjKwV8bDyspX7o=";

  meta = {
    description = "MozillaVPN configuration manager giving Linux, macOS users (among others), access to MozillaVPN";
    homepage = "https://github.com/NilsIrl/MozWire";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [
      siraben
      nilsirl
    ];
    mainProgram = "mozwire";
  };
})
