{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "coconutbattery";
  version = "3.9.14";

  src = fetchzip {
    url = "https://coconut-flavour.com/downloads/coconutBattery_${
      builtins.replaceStrings [ "." ] [ "" ] finalAttrs.version
    }.zip";
    hash = "sha256-zKSPKwDBwxlyNJFurCLLGtba9gpizJCjOOAd81vdD5Q=";
  };

  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications/coconutBattery.app
    cp -R . $out/Applications/coconutBattery.app

    runHook postInstall
  '';

  meta = with lib; {
    description = "Standard for battery reading since 2005";
    longDescription = ''
      With coconutBattery you are always aware of your current battery health.
      It shows you live information about the battery quality in your Mac, iPhone and iPad.
    '';
    homepage = "https://www.coconut-flavour.com/coconutbattery";
    license = with licenses; [ unfree ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ stepbrobd ];
    platforms = [
      "aarch64-darwin"
      "x86_64-darwin"
    ];
  };
})
