{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "bore-cli";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "ekzhang";
    repo = "bore";
    rev = "v${version}";
    hash = "sha256-Jr6jZKsMhSpWVNpmhozI5DLONbwfIpcXwSlcbC9lLRM=";
  };

  cargoHash = "sha256-CLnwzgDbHy6nTfVathycObArtEsF8tpMNoh19/uQqGA=";

  # tests do not find grcov path correctly
  meta = with lib; {
    description = "Rust tool to create TCP tunnels";
    homepage = "https://github.com/ekzhang/bore";
    license = licenses.mit;
    maintainers = with maintainers; [ DieracDelta ];
    mainProgram = "bore";
  };
}
