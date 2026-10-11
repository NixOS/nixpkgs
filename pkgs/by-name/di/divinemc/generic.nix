{
  lib,
  stdenvNoCC,
  fetchurl,
  makeBinaryWrapper,
  jdk17_headless,
  jdk21_headless,
  jdk25_headless,
  udev,
  nixosTests,
  version,
  build,
  channel,
  java,
  url,
  hash,
}:

let
  jdksByVersion = {
    "17" = jdk17_headless;
    "21" = jdk21_headless;
    "25" = jdk25_headless;
  };
  available = lib.sort lib.lessThan (map lib.toInt (builtins.attrNames jdksByVersion));
  minimum = if java == null then lib.head available else java;
  chosen = lib.findFirst (v: v >= minimum) (lib.last available) available;
  jre = jdksByVersion.${toString chosen};
in

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "divinemc";
  inherit version;

  src = fetchurl { inherit url hash; };

  nativeBuildInputs = [ makeBinaryWrapper ];

  dontUnpack = true;
  preferLocalBuild = true;
  allowSubstitutes = false;

  strictDeps = true;
  __structuredAttrs = true;

  installPhase = ''
    runHook preInstall

    install -D $src $out/share/divinemc/divinemc.jar

    makeWrapper ${lib.getExe jre} "$out/bin/minecraft-server" \
      --append-flags "-jar $out/share/divinemc/divinemc.jar nogui" \
      ${lib.optionalString stdenvNoCC.hostPlatform.isLinux "--prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ udev ]}"}

    runHook postInstall
  '';

  passthru = {
    inherit build channel;
    javaVersion = chosen;
    updateScript = {
      command = [ ./update.py ];
      attrPath = "divinemc";
      supportedFeatures = [ "commit" ];
    };
    tests = { inherit (nixosTests) minecraft-server; };
  };

  meta = {
    description = "Multi-functional fork of Purpur focused on flexibility and optimization (Minecraft ${version})";
    homepage = "https://github.com/BX-Team/DivineMC";
    changelog = "https://bxteam.org/downloads/divinemc";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      nonplay
      wiyba
    ];
    mainProgram = "minecraft-server";
  };
})
