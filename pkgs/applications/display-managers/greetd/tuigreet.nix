{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "tuigreet";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "apognu";
    repo = "tuigreet";
    rev = "refs/tags/${version}";
    sha256 = "sha256-e0YtpakEaaWdgu+bMr2VFoUc6+SUMFk4hYtSyk5aApY=";
  };

  cargoHash = "sha256-RkJjAmZ++4nc/lLh8g0LxGq2DjZGxQEjFOl8Yzx116A=";

  meta = {
    description = "Graphical console greeter for greetd";
    homepage = "https://github.com/apognu/tuigreet";
    changelog = "https://github.com/apognu/tuigreet/releases/tag/${version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ luc65r ];
    platforms = lib.platforms.linux;
    mainProgram = "tuigreet";
  };
}
