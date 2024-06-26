{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  udev,
}:

rustPlatform.buildRustPackage rec {
  pname = "makima";
  version = "0.9.3";

  src = fetchFromGitHub {
    owner = "cyber-sushi";
    repo = "makima";
    rev = "v${version}";
    hash = "sha256-esZCFMeIRoafR7vQbnyf3Mo18trVZdIy9rvAvTHfrLA=";
  };

  cargoHash = "sha256-NXiK+cimQaYpzY3WSHUlYUWcXOLWQ5TwGuZKh+OB+go=";

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
