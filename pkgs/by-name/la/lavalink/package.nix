{
  lib,
  stdenv,
  makeWrapper,
  jdk21,
  jdk ? jdk21,
  fetchurl,
  nixosTests,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lavalink";
  version = "4.1.1";

  src = fetchurl {
    url = "https://github.com/lavalink-devs/Lavalink/releases/download/${finalAttrs.version}/Lavalink.jar";
    hash = "sha256-ZR/5YDgbziAqOR8fex3aMzybPmLy/KOGtNM12Zj/ttg=";
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    makeWrapper ${lib.getExe jdk} $out/bin/lavalink \
      --add-flags "-jar $src"

    runHook postInstall
  '';

  passthru.tests = { inherit (nixosTests) lavalink; };

  meta = {
    description = "Standalone audio sending node based on Lavaplayer and Koe";
    longDescription = ''
      A standalone audio sending node based on Lavaplayer and Koe. Allows for sending audio without it ever reaching any of your shards.

      Being used in production by FredBoat, Dyno, LewdBot, and more.
    '';
    homepage = "https://lavalink.dev/";
    changelog = "https://github.com/lavalink-devs/Lavalink/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nanoyaki ];
    sourceProvenance = [ lib.sourceTypes.binaryBytecode ];
    mainProgram = "lavalink";
    inherit (jdk.meta) platforms;
  };
})
