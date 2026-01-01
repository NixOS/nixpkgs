{ lib, fetchFromGitHub }:
let
  version = "0.22.1";
in
{
  inherit version;

  src = fetchFromGitHub {
    owner = "Donkie";
    repo = "Spoolman";
    rev = "v${version}";
    hash = "sha256-EVGpwcjEh4u8Vtgu2LypqMqArYLZe7oh1qYhGZpgjh0=";
  };

<<<<<<< HEAD
  meta = {
    description = "Keep track of your inventory of 3D-printer filament spools";
    homepage = "https://github.com/Donkie/Spoolman";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
=======
  meta = with lib; {
    description = "Keep track of your inventory of 3D-printer filament spools";
    homepage = "https://github.com/Donkie/Spoolman";
    license = licenses.mit;
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      MayNiklas
      pinpox
    ];
    mainProgram = "spoolman";
  };
}
