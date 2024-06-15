{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage {
  pname = "cargo-pretty-test";
  version = "0.2.5";

  src = fetchFromGitHub {
    owner = "josecelano";
    repo = "cargo-pretty-test";
    rev = "23e7a940f1e3c4a778f0ed1aebb67a31b5a85c70";
    hash = "sha256-VnnhSgvNfqXLKTYe+Sef9H80+Ym7BBo7Jnfd2eMWF4U=";
  };

  cargoHash = "sha256-oi0kepWW8AX0ysf9vjdBDAdS+wKPmJl8SKLTAfsXRxs=";

  meta = with lib; {
    description = "A console command to format cargo test output";
    homepage = "https://github.com/josecelano/cargo-pretty-test";
    license = licenses.mit;
    maintainers = with maintainers; [ sergioribera ];
    mainProgram = "cargo-pretty-test";
  };
}
