{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  udev,
}:

rustPlatform.buildRustPackage rec {
  pname = "makima";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "cyber-sushi";
    repo = "makima";
    rev = "v${version}";
    hash = "sha256-kC0GJ1K7DMfkYxaYog5y1y0DMfFjZ7iD7pGQQE67N9o=";
  };

  cargoHash = "sha256-70gkCv9YHeHj1Hj9gLTvHTRULEJJwezaqSECWbgPIc4=";

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
