{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
}:

rustPlatform.buildRustPackage rec {
  pname = "icnsify";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "uncenter";
    repo = "icnsify";
    rev = "v${version}";
    hash = "sha256-v8jwN29S6ZTt2XkPpZM+lJugbP9ClzPhqu52mdwdP00=";
  };

  cargoHash = "sha256-5wgioCOKvZ0J/t5v/Ic3unAA5h5Bt6MuCUzFJP7Dusw=";

  nativeBuildInputs = [
    pkg-config
  ];

  meta = with lib; {
    description = "Convert PNGs to .icns";
    homepage = "https://github.com/uncenter/icnsify";
    changelog = "https://github.com/uncenter/icnsify/blob/${src.rev}/changelogithub.config.json";
    license = licenses.mit;
    maintainers = with maintainers; [ iogamaster ];
    mainProgram = "icnsify";
  };
}
