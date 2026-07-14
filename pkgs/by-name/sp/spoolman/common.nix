{ lib, fetchFromGitHub }:
let
  version = "0.23.1";
in
{
  inherit version;

  src = fetchFromGitHub {
    owner = "Donkie";
    repo = "Spoolman";
    rev = "v${version}";
    hash = "sha256-Oa/cNmpc0hWRf0EQI5aXIE/p9//Sos5Nj3QFEjKgj5o=";
  };

  meta = {
    description = "Keep track of your inventory of 3D-printer filament spools";
    homepage = "https://github.com/Donkie/Spoolman";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      MayNiklas
      pinpox
    ];
    mainProgram = "spoolman";
  };
}
