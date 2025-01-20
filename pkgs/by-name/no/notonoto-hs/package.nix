{
  lib,
  fetchzip,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation rec {
  pname = "notonoto-hs";
  version = "0.0.3";

  src = fetchzip {
    url = "https://github.com/yuru7/NOTONOTO/releases/download/v${version}/NOTONOTO_HS_v${version}.zip";
    hash = "sha256-TUlrASn7Lfyb9UoUk0ssV2j+ereqzRQAsnHCMkTL+04=";
  };

  installPhase = ''
    runHook preInstall
    install -Dm444 NOTONOTO_HS/*.ttf -t $out/share/fonts/truetype/notonoto-hs
    install -Dm444 NOTONOTO35_HS/*.ttf -t $out/share/fonts/truetype/notonoto-hs-35
    install -Dm444 NOTONOTOConsole_HS/*.ttf -t $out/share/fonts/truetype/notonoto-hs-console
    install -Dm444 NOTONOTO35Console_HS/*.ttf -t $out/share/fonts/truetype/notonoto-hs-35console
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
