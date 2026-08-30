{
  stdenvNoCC,
  fetchFromGitHub,
  lib,
  variant ? "Gruvbox-Dark-Brown",
}:
let
  pname = "gruvbox-kvantum";
in
lib.checkListOfEnum "${pname}: variant"
  [
    "Gruvbox-Dark-Blue"
    "Gruvbox-Dark-Brown"
    "Gruvbox-Dark-Green"
    "Gruvbox_Light_Blue"
    "Gruvbox_Light_Brown"
    "Gruvbox_Light_Green"
  ]
  [ variant ]

  stdenvNoCC.mkDerivation
  {
    inherit pname;
    version = "1.1";

    src = fetchFromGitHub {
      owner = "sachnr";
      repo = "gruvbox-kvantum-themes";
      rev = "f47670be407c1f07c64890ad53884ee9977a7db1";
      sha256 = "sha256-u2J4Zf9HuMjNCt3qVpgEffkytl/t277FzOvWL8Nm8os=";
    };

    installPhase = ''
      runHook preInstall
      mkdir -p $out/share/Kvantum
      cp -a "${variant}" $out/share/Kvantum
      runHook postInstall
    '';

    meta = {
      description = "Gruvbox themes for kvantum";
      homepage = "https://github.com/sachnr/gruvbox-kvantum-themes";
      license = lib.licenses.gpl3;
      platforms = lib.platforms.linux;
      maintainers = with lib.maintainers; [ istudyatuni ];
    };
  }
