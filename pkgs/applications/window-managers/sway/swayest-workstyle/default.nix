{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "swayest-workstyle";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "Lyr-7D1h";
    repo = "swayest_workstyle";
    rev = version;
    sha256 = "sha256-C2Nz6fBwaj+cOxIfoBu+9T+CoJ5Spc1TAJcQWdIF/+I=";
  };

  cargoHash = "sha256-6pAlJmpyv2a1XCZQLOYilxJAGPbPmkEz1ynTLa0RjE0=";

  doCheck = false; # No tests

  meta = with lib; {
    description = "Map sway workspace names to icons defined depending on the windows inside of the workspace";
    homepage = "https://github.com/Lyr-7D1h/swayest_workstyle";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ miangraham ];
    mainProgram = "sworkstyle";
  };
}
