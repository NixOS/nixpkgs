{ lib
, stdenvNoCC
, fetchFromGitHub
}:

stdenvNoCC.mkDerivation rec {
  pname = "libretro-core-info";
  version = "1.12.0";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "libretro-core-info";
    hash = "sha256-ByATDM0V40UJxigqVLyTWkHY5tiCC2dvZebksl8GsUI=";
    rev = "v${version}";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  dontBuild = true;

  meta = with lib; {
    description = "Libretro's core info files";
    homepage = "https://libretro.com";
    license = licenses.mit;
    maintainers = with maintainers; teams.libretro.members ++ [ ];
    platforms = platforms.all;
  };
}
