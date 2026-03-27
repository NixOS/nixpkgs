{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "coconutbattery";
  version = "4.2.0,192";

  src = fetchzip {
    url = "https://coconut-flavour.com/downloads/coconutBattery_${
      lib.replaceStrings [ "." "," ] [ "" "_" ] finalAttrs.version
    }.zip";
    hash = "sha256-pzfg+RAlCbEaBHiU/ZQcBf0Tg0BCfs0UHh62dFQVbz0=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications/coconutBattery.app
    cp -R . $out/Applications/coconutBattery.app

    runHook postInstall
  '';

  meta = {
    description = "Standard for battery reading since 2005";
    longDescription = ''
      With coconutBattery you are always aware of your current battery health.
      It shows you live information about the battery quality in your Mac, iPhone and iPad.
    '';
    homepage = "https://www.coconut-flavour.com/coconutbattery";
    license = with lib.licenses; [ unfree ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ stepbrobd ];
    platforms = [
      "aarch64-darwin"
      "x86_64-darwin"
    ];
  };
})
