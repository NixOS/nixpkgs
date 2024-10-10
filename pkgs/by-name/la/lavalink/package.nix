{
  lib,
  stdenv,
  makeWrapper,
  pkg-config,
  systemd,
  jdk,
  fetchurl,
  nixosTests,
}:

stdenv.mkDerivation (finalAttrs: {
  name = "lavalink";
  version = "4.0.8";

  src = fetchurl {
    url = "https://github.com/lavalink-devs/Lavalink/releases/download/${finalAttrs.version}/Lavalink.jar";
    hash = "sha256-G4a9ltPq/L0vcazTQjStTlOOtwrBi37bYUNQHy5CV9Y=";
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  dontUnpack = true;

  installPhase = ''
    makeWrapper ${lib.getExe jdk} $out/bin/lavalink \
      --add-flags "-jar $src"
  '';

  passthru.tests = {
    info = nixosTests.lavalink;
  };

  meta = {
    description = "A standalone audio sending node based on Lavaplayer and Koe";
    longDescription = ''
      A standalone audio sending node based on Lavaplayer and Koe. Allows for sending audio without it ever reaching any of your shards.

      Being used in production by FredBoat, Dyno, LewdBot, and more.
    '';
    homepage = "https://lavalink.dev/";
    changelog = "https://github.com/lavalink-devs/Lavalink/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nanoyaki ];
    mainProgram = "lavalink";
    platforms = jdk.meta.platforms;
  };
})
