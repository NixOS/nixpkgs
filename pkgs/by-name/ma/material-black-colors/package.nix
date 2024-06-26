{ lib
, stdenvNoCC
, fetchFromGitHub
, colorVariants ? [] # default: install all icons
}:

let
  pname = "material-black-colors";
  colorVariantList = [
    "MB-Blueberry-Suru-GLOW"
    "MB-Cherry-Suru-GLOW"
    "MB-Lime-Suru-GLOW"
    "MB-Mango-Suru-GLOW"
    "MB-Pistachio-Suru-GLOW"
    "MB-Plum-Suru-GLOW"
    "Material-Black-Blueberry-Numix-FLAT"
    "Material-Black-Blueberry-Numix"
    "Material-Black-Blueberry-Suru"
    "Material-Black-Cherry-Numix-FLAT"
    "Material-Black-Cherry-Numix"
    "Material-Black-Cherry-Suru"
    "Material-Black-Lime-Numix-FLAT"
    "Material-Black-Lime-Numix"
    "Material-Black-Lime-Suru"
    "Material-Black-Mango-Numix-FLAT"
    "Material-Black-Mango-Numix"
    "Material-Black-Mango-Suru"
    "Material-Black-Pistachio-Numix-FLAT"
    "Material-Black-Pistachio-Numix"
    "Material-Black-Pistachio-Suru"
    "Material-Black-Plum-Numix-FLAT"
    "Material-Black-Plum-Numix"
    "Material-Black-Plum-Suru"
  ];

in
lib.checkListOfEnum "${pname}: color variants" colorVariantList colorVariants

stdenvNoCC.mkDerivation {
  inherit pname;
  version = "0-unstable-2020-12-17";

  src = fetchFromGitHub {
    owner = "rtlewis88";
    repo = "rtl88-Themes";
    rev = "3864d851aac7f4e76cf23717aee104de234aef74";
    hash = "sha256-BUJMd6Ltq16/HqqDbB5VDGIRSzLivXxNYZPT9sd6oTI=";
  };

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/icons
    cp -r ${lib.concatStringsSep " " (if colorVariants != [] then colorVariants else colorVariantList)} $out/share/icons/
    runHook postInstall
  '';

  dontFixup = true;

  meta = with lib; {
    description = "Material Black Colors icons";
    homepage = "https://github.com/rtlewis88/rtl88-Themes/tree/material-black-COLORS";
    maintainers = with maintainers; [ d3vil0p3r ];
    platforms = platforms.all;
    license = with licenses; [ gpl3Plus mit ];
  };
}
