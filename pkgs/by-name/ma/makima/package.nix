{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  udev,
}:

rustPlatform.buildRustPackage rec {
  pname = "makima";
  version = "0.9.4";

  src = fetchFromGitHub {
    owner = "cyber-sushi";
    repo = "makima";
    rev = "v${version}";
    hash = "sha256-cmn86ocN8DwxS9WpcHxWMjuFPAMmM60Q6jmyeBmdrPg=";
  };

  cargoHash = "sha256-/eM+clDZRlvfFa1eEwLo8CKEvnOq5CW19RNvbEbxVE8=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ udev ];

  meta = with lib; {
    description = "Linux daemon to remap and create macros for keyboards, mice and controllers";
    homepage = "https://github.com/cyber-sushi/makima";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ByteSudoer ];
    platforms = platforms.linux;
    mainProgram = "makima";
  };
}
