{ lib, fetchFromGitHub }:
let
  version = "0.26.1";
in
{
  inherit version;

  src = fetchFromGitHub {
    owner = "Donkie";
    repo = "Spoolman";
    rev = "v${version}";
    hash = "sha256-tBHU4WvknqkRNxlQJ/wuzM3mrQVyMS3eED1Kimi6rsU=";
  };

  meta = {
    description = "Keep track of your inventory of 3D-printer filament spools";
    homepage = "https://github.com/Donkie/Spoolman";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      MayNiklas
      pinpox
    ];
  };
}
