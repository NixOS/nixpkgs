{ lib
, stdenvNoCC
, fetchFromGitLab
, colorVariants ? [] # default: install all icons
}:

let
  pname = "fairywren";
  colorVariantList = [
    "FairyWren_Dark"
    "FairyWren_Light"
  ];

in
lib.checkListOfEnum "${pname}: colorVariants" colorVariantList colorVariants

stdenvNoCC.mkDerivation {
  inherit pname;
  version = "0-unstable-2024-06-10";

  src = fetchFromGitLab{
    owner = "aiyahm";
    repo = "FairyWren-Icons";
    rev = "a86736cc9ff50af0ca59ef31c464da2f9e9da103";
    hash = "sha256-IzTq45lMdlAt+mEb7gpp1hWKBUSeLWINK53Sv4RithI=";
  };

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/icons
    cp -r ${lib.concatStringsSep " " (if colorVariants != [] then colorVariants else colorVariantList)} $out/share/icons/
    runHook postInstall
  '';

  dontFixup = true;

  meta = with lib; {
    description = "FairyWren Icon Set";
    homepage = "https://gitlab.com/aiyahm/FairyWren-Icons";
    maintainers = with maintainers; [ d3vil0p3r ];
    platforms = platforms.all;
    license = with licenses; [ gpl3Plus ];
  };
}
