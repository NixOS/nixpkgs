{ lib
, stdenvNoCC
, fetchurl
, gtk3
, hicolor-icon-theme
, gitUpdater
,
}:

let
  version = "20260529";

  variants = {
    archdroid-abyss = fetchurl {
      url = "https://github.com/eldritch-theme/icon-theme/releases/download/${version}/Eldritch-Archdroid-Abyss.tar.xz";
      hash = "sha256-e0vxIv4IE22dViNPh9fGAWGNdiGLxBAnuIIJ8QGh66Q=";
    };
    archdroid-cthulhu = fetchurl {
      url = "https://github.com/eldritch-theme/icon-theme/releases/download/${version}/Eldritch-Archdroid-Cthulhu.tar.xz";
      hash = "sha256-yi/Xhy9PyJMBOhJOXapWA4+BfYoIo1VsTTVyEOOpwco=";
    };
    archdroid-dusk = fetchurl {
      url = "https://github.com/eldritch-theme/icon-theme/releases/download/${version}/Eldritch-Archdroid-Dusk.tar.xz";
      hash = "sha256-yBHmpRVvkqpzVwgYV0mlzSMoDa/FTqNHG13rlaVSRSI=";
    };
    suru-abyss = fetchurl {
      url = "https://github.com/eldritch-theme/icon-theme/releases/download/${version}/Eldritch-Suru-Abyss.tar.xz";
      hash = "sha256-PVnz9oE3Vrj8bqOpOurLIcNLfwWLouwAPD468Bwmtik=";
    };
    suru-cthulhu = fetchurl {
      url = "https://github.com/eldritch-theme/icon-theme/releases/download/${version}/Eldritch-Suru-Cthulhu.tar.xz";
      hash = "sha256-HilMQCo3vaZxz1LcCyV5/9SNZ536CkQ9c2c9b14mIbA=";
    };
    suru-dusk = fetchurl {
      url = "https://github.com/eldritch-theme/icon-theme/releases/download/${version}/Eldritch-Suru-Dusk.tar.xz";
      hash = "sha256-YWZgTy7h7VGHWFCBA6++HpsoUnNbatl4YG2GG7Kd0oY=";
    };
  };
in
stdenvNoCC.mkDerivation {
  pname = "eldritch-icon-theme";
  inherit version;

  srcs = lib.attrValues variants;

  sourceRoot = ".";

  nativeBuildInputs = [ gtk3 ];

  propagatedBuildInputs = [ hicolor-icon-theme ];

  strictDeps = true;
  __structuredAttrs = true;

  dontDropIconThemeCache = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/icons
    for d in Eldritch-*; do
      if [ -d "$d" ]; then
        mv "$d" "$out/share/icons/"
      fi
    done

    for theme in $out/share/icons/*; do
      gtk-update-icon-cache --force "$theme"
    done

    runHook postInstall
  '';

  passthru.updateScript = gitUpdater { };

  meta = {
    description = "Lovecraftian dark icon themes for the Eldritch desktop";
    longDescription = ''
      Eldritch icon theme pack containing Archdroid-based and Suru-based icon
      themes in Abyss, Cthulhu, and Dusk color palettes.

      Included icon themes:
      - Eldritch-Archdroid-Abyss
      - Eldritch-Archdroid-Cthulhu
      - Eldritch-Archdroid-Dusk
      - Eldritch-Suru-Abyss
      - Eldritch-Suru-Cthulhu
      - Eldritch-Suru-Dusk
    '';
    homepage = "https://github.com/eldritch-theme/icon-theme";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ neonvoidx ];
  };
}
