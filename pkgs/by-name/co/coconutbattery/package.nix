{ lib
, stdenvNoCC
, fetchzip
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "coconutbattery";
  version = "3.9.16,278173DA";

  src = fetchzip {
    url =
      let
        versionString = lib.replaceStrings [ "." "," ] [ "" "_" ] finalAttrs.version;
      in
      "https://coconut-flavour.com/downloads/coconutBattery_${versionString}.zip";
    hash = "sha256-0RZK4qXgsUB6oxx4Kn0v5+wGyTIrQQFZIMi1eRe1twE=";
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

  meta = {
    description = "Tool to show live information about the batteries in various devices";
    longDescription = ''
      With coconutBattery you are always aware of your current battery health.
      It shows you live information about the battery quality in your Mac, iPhone and iPad.
    '';
    homepage = "https://www.coconut-flavour.com/coconutbattery";
    license = with lib.licenses; [ unfree ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ stepbrobd ];
    platforms = [ "aarch64-darwin" "x86_64-darwin" ];
  };
})
