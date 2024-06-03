{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "tuigreet";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "apognu";
    repo = pname;
    rev = version;
    sha256 = "sha256-e0YtpakEaaWdgu+bMr2VFoUc6+SUMFk4hYtSyk5aApY=";
  };

  cargoHash = "sha256-RkJjAmZ++4nc/lLh8g0LxGq2DjZGxQEjFOl8Yzx116A=";

  meta = with lib; {
    description = "Graphical console greeter for greetd";
    homepage = "https://github.com/apognu/tuigreet";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ luc65r ivar ];
    platforms = platforms.linux;
    mainProgram = "tuigreet";
  };
}
