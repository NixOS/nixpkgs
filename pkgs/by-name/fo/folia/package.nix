{
  lib,
  stdenvNoCC,
  fetchurl,
  makeBinaryWrapper,
  jdk25_headless,
  udev,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "folia";
  version = "26.1.2-8";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchurl {
    url = "https://fill-data.papermc.io/v1/objects/607afd1c3320008e1ffd2eaee6780ace4419d5f8c527b75e79f259be79ebf57b/folia-26.1.2-8.jar";
    hash = "sha256-YHr9HDMgAI4f/S6u5ngKzkQZ1fjFJ7deefJZvnnr9Xs=";
  };

  dontUnpack = true;

  nativeBuildInputs = [
    makeBinaryWrapper
  ];

  installPhase = ''
    runHook preInstall

    install -D $src $out/share/folia/folia.jar

    makeWrapper ${lib.getExe jdk25_headless} "$out/bin/minecraft-server" \
      --append-flags "-jar $out/share/folia/folia.jar nogui" \
      ${lib.optionalString stdenvNoCC.hostPlatform.isLinux "--prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ udev ]}"}

    runHook postInstall
  '';

  preferLocalBuild = true;
  allowSubstitutes = false;

  passthru = {
    updateScript = ./update.py;
  };

  meta = {
    description = "Fork of Paper which adds regionised multithreading to the dedicated server";
    homepage = "https://papermc.io/software/folia";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ aaravrav ];
    mainProgram = "minecraft-server";
  };
})
