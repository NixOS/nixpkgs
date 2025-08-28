{
  lib,
  stdenvNoCC,
  fetchurl,
  makeWrapper,
  # TODO: for jre 17+, we'll need a workaround:
  # https://gitlab.com/hdos/issues/-/issues/2004
  openjdk11,
  makeDesktopItem,
  copyDesktopItems,
  libGL,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "hdos";
  version = "8";

  src = fetchurl {
    url = "https://cdn.hdos.dev/launcher/v${finalAttrs.version}/hdos-launcher.jar";
    hash = "sha256-00ddeR+ov6Tjrn+pscXoao4C0ek/iP9Hdlgq946pL8A=";
  };

  dontUnpack = true;

  desktop = makeDesktopItem {
    name = "HDOS";
    type = "Application";
    exec = "hdos";
    icon = fetchurl {
      url = "https://raw.githubusercontent.com/flathub/dev.hdos.HDOS/8e17cbecb06548fde2c023032e89ddf30befeabc/dev.hdos.HDOS.png";
      hash = "sha256-pqLNJ0g7GCPotgEPfw2ZZOqapaCRAsJxB09INp6Y6gM=";
    };
    comment = "HDOS is a client for Old School RuneScape that emulates the era of 2008-2011 RuneScape HD";
    desktopName = "HDOS";
    genericName = "Oldschool Runescape";
    categories = [ "Game" ];
  };

  nativeBuildInputs = [
    makeWrapper
    copyDesktopItems
  ];

  installPhase = ''
    runHook preInstall
    makeWrapper ${lib.getExe openjdk11} $out/bin/hdos \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ libGL ]}" \
      --add-flags "-jar $src"
    runHook postInstall
  '';

  desktopItems = [ finalAttrs.desktop ];

  passthru.updateScript = ./update.sh;

  meta = {
    description = "High Detail Old School Runescape Client";
    homepage = "https://hdos.dev";
    changelog = "https://hdos.dev/changelog";
    sourceProvenance = [ lib.sourceTypes.binaryBytecode ];
    license = lib.licenses.unfree;
    platforms = openjdk11.meta.platforms;
    maintainers = [ lib.maintainers.misterio77 ];
  };
})
