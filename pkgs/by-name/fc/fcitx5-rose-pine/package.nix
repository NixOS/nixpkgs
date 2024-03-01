{ stdenvNoCC
, fetchFromGitHub
, lib
}:

stdenvNoCC.mkDerivation {
  pname = "fcitx5-rose-pine";
  version = "0-unstable-2024-03-01";
  
  src = fetchFromGitHub {
    owner = "rose-pine";
    repo = "fcitx5";
    rev = "148de09929c2e2f948376bb23bc25d72006403bc";
    hash = "0gywb8ykb2j3zyr20w1mc3f5xfw2aw4v9b821d55w36ja753k52a";
  };

  installPhase = ''
    runHook preInstall

    mkdir -pv $out/share/fcitx5/themes/
    cp -rv rose-pine* $out/share/fcitx5/themes/

    runHook postInstall
  '';


  meta = {
    description = "Fcitx5 themes based on Rosé Pine";
    homepage = "https://github.com/rose-pine/fcitx5";
    maintainers = with lib.maintainers; [ RoseHobgoblin ];
    platforms = lib.platforms.all;
  };
}
