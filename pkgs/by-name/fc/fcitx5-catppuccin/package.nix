{ stdenvNoCC
, fetchFromGitHub
, lib
}:

stdenvNoCC.mkDerivation {
  pname = "fcitx5-catppuccin";
  version = "2022-10-05";

  src = fetchFromGitHub {
    owner = "catppuccin";
    repo = "fcitx5";
    rev = "ce244cfdf43a648d984719fdfd1d60aab09f5c97";
    hash = "sha256-uFaCbyrEjv4oiKUzLVFzw+UY54/h7wh2cntqeyYwGps=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -pv $out/share/fcitx5/themes/
    cp -rv src/catppuccin-{frappe,latte,macchiato,mocha} \
      $out/share/fcitx5/themes/

    runHook postInstall
  '';

  meta = with lib; {
    description = "Soothing pastel themes for Fcitx5";
    homepage = "https://github.com/catppuccin/fcitx5";
    license = licenses.mit;
    maintainers = with maintainers; [ lilacious ];
    platforms = platforms.all;
  };
}
