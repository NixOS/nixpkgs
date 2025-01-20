{
  lib,
  fetchzip,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation rec {
  pname = "notonoto";
  version = "0.0.3";

  src = fetchzip {
    url = "https://github.com/yuru7/NOTONOTO/releases/download/v${version}/NOTONOTO_v${version}.zip";
    hash = "sha256-Yww8c8INAQIOFZuCLgEVm6HycQ1AkpK8F45dmyeF70g=";
  };

  installPhase = ''
    runHook preInstall
    install -Dm444 NOTONOTO/*.ttf -t $out/share/fonts/truetype/notonoto
    install -Dm444 NOTONOTO35/*.ttf -t $out/share/fonts/truetype/notonoto-35
    install -Dm444 NOTONOTOConsole/*.ttf -t $out/share/fonts/truetype/notonoto-console
    install -Dm444 NOTONOTO35Console/*.ttf -t $out/share/fonts/truetype/notonoto-35console
    runHook postInstall
  '';

  meta = {
    description = "Programming font that combines Noto Sans Mono and Noto Sans JP";
    homepage = "https://github.com/yuru7/NOTONOTO";
    license = lib.licenses.ofl;
    maintainers = with lib.maintainers; [ genga898 ];
    platforms = lib.platforms.all;
  };
}
