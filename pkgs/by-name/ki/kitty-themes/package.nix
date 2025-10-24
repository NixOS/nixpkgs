{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  jq,
  symlinkJoin,
}:
let
  version = "0-unstable-2024-08-14";

  src = fetchFromGitHub {
    owner = "kovidgoyal";
    repo = "kitty-themes";
    rev = "cdf1ed4134815f58727f8070f997552f86b58892";
    hash = "sha256-vt5y3Ai1KMgRhFrkfhA8G9Ve6BEFrgkCF3ssGlOdekw=";
  };

  convertAttrName =
    name: lib.replaceStrings [ " - " "_" " " "(" ")" ] [ "-" "-" "-" "" "" ] (lib.strings.toLower name);

  licenseMap = with lib.licenses; {
    "CC-BY-SA-4.0" = cc-by-nc-sa-40;
    "CC0 1.0" = cc0;
    "CC0 Public Domain" = cc0;
    "GNU GPLv3" = gpl3Only;
    "GNU General Public License v3.0" = gpl3Plus;
    "GPL-3" = gpl3Only;
    "GPLv3" = gpl3Only;
    "GPLv3+" = gpl3Plus;
    "LGPL-3.0" = lgpl3;
    "MIT license - https://www.mit.edu/~amini/LICENSE.md" = mit;
    "MIT" = mit;
    "MIT, I prefer credit (and money) to none, but I won't sue" = mit;
    "MIT/X11" = [
      mit
      x11
    ];
    "UPL-1.0" = upl;
    "unfree" = unfree;
  };

  makeKittyTheme =
    {
      name,
      caskName ? convertAttrName name,
      blurb ? "Kitty theme ${name}",
      file,
      license ? "unfree",
      ...
    }:

    stdenvNoCC.mkDerivation {
      pname = "kitty-theme-${caskName}";

      inherit src version;

      dontConfigure = true;
      dontBuild = true;

      nativeBuildInputs = [ jq ];

      installPhase = ''
        runHook preInstall

        mkdir -p $out/share/kitty-themes
        mv ${file} $out/share/kitty-themes

        jq '[.[] | select(.name == "${name}")]' themes.json \
          > $out/share/kitty-themes/themes.json

        runHook postInstall
      '';

      meta = {
        homepage = "https://github.com/kovidgoyal/kitty-themes";
        description = blurb;
        license = lib.flatten [
          lib.licenses.gpl3Only # themes.json
          licenseMap.${license}
        ];
        maintainers = with lib.maintainers; [ sigmanificient ];
        platforms = lib.platforms.all;
      };
    };

  themes = lib.listToAttrs (
    map (theme: {
      name = convertAttrName theme.name;
      value = makeKittyTheme theme;
    }) (lib.importJSON ./themes.json)
  );
in themes
