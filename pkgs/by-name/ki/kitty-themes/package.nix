{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  jq,
  symlinkJoin,
}:
let
  version = "0-unstable-2025-10-24";

  src = fetchFromGitHub {
    owner = "kovidgoyal";
    repo = "kitty-themes";
    rev = "6af4bcd7244a20ce4a0244c9128003473b97f319";
    hash = "sha256-oxNdwv5q3aEC6kCEZzZawrIYq0gYSVMjB4xVPb5WiEE=";
  };

  convertAttrName =
    name: lib.replaceStrings [ " - " "_" " " "(" ")" ] [ "-" "-" "-" "" "" ] (lib.strings.toLower name);

  licenseMap = with lib.licenses; {
    "CC-BY-SA-4.0" = cc-by-nc-sa-40;
    "CC0-1.0" = cc0;
    "GPL-3.0" = gpl3Only;
    "GPL-3.0-or-later" = gpl3Plus;
    "LGPL-3.0" = lgpl3;
    "MIT" = mit;
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
