{ lib, fetchFromGitHub }:
let
  version = "unstable-2024-05-31";
in
{
  inherit version;

  src = fetchFromGitHub {
    owner = "Donkie";
    repo = "Spoolman";
    rev = "8f2cc05a7cf78ad1a5d38abd32018702b0578bce";
    hash = "sha256-bQh7BQLWlQklouZh1gELNS7VbBdqL1lyX5PFK/kZR/c";
  };

  meta = with lib; {
    description = "Keep track of your inventory of 3D-printer filament spools";
    homepage = "https://github.com/Donkie/Spoolman";
    license = licenses.mit;
    maintainers = with maintainers; [ pinpox MayNiklas ];
    mainProgram = "spoolman";
  };
}
