{
  lib,
  stdenv,
  fetchurl,
  jre,
  makeBinaryWrapper,
  copyDesktopItems,
  makeDesktopItem,
}:

let
  desktopicon = fetchurl {
    name = "netlogo.png";
    url = "https://netlogoweb.org/assets/images/desktopicon.png";
    hash = "sha256-KCsXt1dnBNUEBKvusp5JpKOSH7u9gSwaUvvTMDKkg8Q=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "netlogo";
  version = "6.4.0";

  src = fetchurl {
    url = "https://ccl.northwestern.edu/netlogo/${finalAttrs.version}/NetLogo-${finalAttrs.version}-64.tgz";
    hash = "sha256-hkciO0KC4L4+YtycRSB/gkELpj3SiSsIrylAy6pq0d4=";
  };

  nativeBuildInputs = [
    makeBinaryWrapper
    copyDesktopItems
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "netlogo";
      exec = "netlogo";
      icon = "netlogo";
      comment = "A multi-agent programmable modeling environment";
      desktopName = "NetLogo";
      categories = [ "Science" ];
    })
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/opt
    cp -r lib/app $out/opt/netlogo
    # launcher with `cd` is required b/c otherwise the model library isn't usable
    makeWrapper ${jre}/bin/java $out/bin/netlogo \
      --chdir $out/opt/netlogo \
      --add-flags "-jar netlogo-${finalAttrs.version}.jar"
    install -Dm644 ${desktopicon} $out/share/pixmaps/netlogo.png

    runHook postInstall
  '';

  meta = {
    description = "Multi-agent programmable modeling environment";
    mainProgram = "netlogo";
    longDescription = ''
      NetLogo is a multi-agent programmable modeling environment. It is used by
      many tens of thousands of students, teachers and researchers worldwide.
    '';
    homepage = "https://ccl.northwestern.edu/netlogo/index.shtml";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.dpaetzel ];
    platforms = lib.platforms.linux;
  };
})
