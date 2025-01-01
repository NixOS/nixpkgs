{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "epilys-bb";
  version = "unstable-2020-12-04";

  src = fetchFromGitHub {
    owner = "epilys";
    repo = "bb";
    rev = "c903d4c2975509299fd3d2600a0c4c2102f445d0";
    hash = "sha256-KOXK+1arUWtu/QU7dwXhojIM0faMtwNN3AqVbofq1lY=";
  };

  cargoHash = "sha256-+aCMwKOg+3HDntG14gjJLec8XD51wuTyYyzLjuW6lbY=";

  meta = with lib; {
    description = "Clean, simple, and fast process viewer";
    homepage = "https://nessuent.xyz/bb.html";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ cafkafk ];
    platforms = platforms.linux;
    mainProgram = "bb";
  };
}
