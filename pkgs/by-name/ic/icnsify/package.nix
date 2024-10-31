{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
let
  version = "0.1.0";
in
rustPlatform.buildRustPackage {
  pname = "icnsify";
  inherit version;

  src = fetchFromGitHub {
    owner = "uncenter";
    repo = "icnsify";
    rev = "v${version}";
    hash = "sha256-v8jwN29S6ZTt2XkPpZM+lJugbP9ClzPhqu52mdwdP00=";
  };

  cargoHash = "sha256-5wgioCOKvZ0J/t5v/Ic3unAA5h5Bt6MuCUzFJP7Dusw=";

  meta = {
    description = "Convert PNGs to .icns";
    homepage = "https://github.com/uncenter/icnsify";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ uncenter ];
    mainProgram = "icnsify";
  };
}
