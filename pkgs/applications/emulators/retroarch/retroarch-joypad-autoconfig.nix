{ lib
, stdenvNoCC
, fetchFromGitHub
}:

stdenvNoCC.mkDerivation rec {
  pname = "retroarch-joypad-autoconfig";
  version = "unstable-2023-08-01";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "retroarch-joypad-autoconfig";
    rev = "5666e46bb89caf4e9af358fdb97a2b384cb62f36";
    hash = "sha256-5Po0v0E/dc+nVHnHlJRZzv66B/DKYarwqTkS9+/ktC4=";
  };

  makeFlags = [
    "PREFIX=$(out)"
  ];

  meta = with lib; {
    description = "Joypad autoconfig files";
    homepage = "https://www.libretro.com/";
    license = licenses.mit;
    maintainers = with maintainers; teams.libretro.members ++ [ ];
    platforms = platforms.all;
  };
}
