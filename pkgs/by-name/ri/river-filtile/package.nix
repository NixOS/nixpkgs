{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
}:

rustPlatform.buildRustPackage rec {
  pname = "river-filtile";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "pkulak";
    repo = "filtile";
    rev = "v${version}";
    hash = "sha256-Zcn0hjq4bJ1V5fwaMUq3XSlGaG9QdwsVxN3aHBKAgZs=";
  };

  cargoHash = "sha256-xA0k9FS8GjI5945uztwcUOJwEFJcBeWgEZTOu0Xocno=";

  nativeBuildInputs = [
    pkg-config
  ];

  meta = with lib; {
    description = "A layout manager for the River window manager";
    homepage = "https://github.com/pkulak/filtile";
    license = licenses.gpl3Only;
    maintainers = with lib.maintainers; [ pkulak ];
    mainProgram = "filtile";
  };
}
