{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "tuigreet";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "apognu";
    repo = pname;
    rev = version;
    sha256 = "sha256-8/2I6bk29/GqZ1ACuN9RgBiGAy7yt0iw2fagHfu4/BI=";
  };

  cargoSha256 = "sha256-fOs9a0/1c8Kh4JA5up3XSQ+km/FwSYzl0w4UDL4yU4M=";

  meta = with lib; {
    description = "Graphical console greeter for greetd";
    homepage = "https://github.com/apognu/tuigreet";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ luc65r ivar ];
    platforms = platforms.linux;
    mainProgram = "tuigreet";
  };
}
