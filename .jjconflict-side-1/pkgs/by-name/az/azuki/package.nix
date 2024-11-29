{
  lib,
  stdenvNoCC,
  fetchzip,
}:

let
  fonts = [
    {
      name = "azuki";
      downloadVersion = "121";
      hash = "sha256-AMpEJDD8lN0qWJ5C0y4V+/2JE/pKQrUHGfKHcnV+dhA=";
    }
    {
      name = "azuki-b";
      downloadVersion = "B120";
      hash = "sha256-GoXnDX9H6D1X0QEgrD2jmQp7ek081PpO+xR3OdIY8Ck=";
    }
    {
      name = "azuki-l";
      downloadVersion = "L120";
      hash = "sha256-rvWvSuvLnK3m2+iyKPQyIB1UGjg8dAW5oygjsLCQZ48=";
    }
    {
      name = "azuki-lb";
      downloadVersion = "LB100";
      hash = "sha256-zpGomVshCe2W2Z2C5UGtVrJ2k7F//MftndSHPHmG290=";
    }
    {
      name = "azuki-lp";
      downloadVersion = "LP100";
      hash = "sha256-Q/ND3dv8q7WTQx4oYVY5pTiGl4Ht89oA+tuCyfPOLUk=";
    }
    {
      name = "azuki-p";
      downloadVersion = "P100";
      hash = "sha256-s4uodxyXP5R7jwkzjmg6qJZCllJ/MtgkkVOeELI8hLI=";
    }
  ];

in
stdenvNoCC.mkDerivation {
  pname = "azuki";
  version = "0-unstable-2021-07-02";

  sourceRoot = "azuki";

  srcs = map (
    {
      name,
      downloadVersion,
      hash,
    }:
    fetchzip {
      url = "https://azukifont.com/font/azukifont${downloadVersion}.zip";
      stripRoot = false;
      inherit name hash;
    }
  ) fonts;

  installPhase = ''
    runHook preInstall

    for font in $srcs; do
      install -Dm644 $font/azukifont*/*.ttf -t $out/share/fonts/truetype
    done

    runHook postInstall
  '';

  meta = {
    homepage = "http://azukifont.com/font/azuki.html";
    description = "Azuki Font";
    license = lib.licenses.unfree;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ nyadiia ];
  };
}
