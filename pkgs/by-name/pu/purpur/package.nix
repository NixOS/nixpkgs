{
  lib,
  stdenv,
  fetchurl,
  nixosTests,
  jre_headless,
  makeWrapper,
  udev,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "purpur";
  version = "26.2r2622";

  src = fetchurl {
    url = "https://api.purpurmc.org/v2/purpur/${
      builtins.replaceStrings [ "r" ] [ "/" ] finalAttrs.version
    }/download";

    sha256 = "sha256-p9DZDTf64SrxbMXSMGTqh91LTje9pdEIHhzvOGAbC6M=";
  };

  nativeBuildInputs = [ makeWrapper ];

  preferLocalBuild = true;

  installPhase = ''
    mkdir -p $out/bin $out/lib/minecraft
    cp -v $src $out/lib/minecraft/server.jar

    makeWrapper ${lib.getExe jre_headless} $out/bin/minecraft-server \
      --append-flags "-jar $out/lib/minecraft/server.jar nogui" \
      ${lib.optionalString stdenv.hostPlatform.isLinux "--prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ udev ]}"}
  '';

  dontUnpack = true;

  passthru = {
    tests = { inherit (nixosTests) minecraft-server; };
  };

  meta = {
    description = "Drop-in replacement for Minecraft Paper servers";
    longDescription = ''
      Purpur is a drop-in replacement for Minecraft Paper servers designed for configurability, new fun and exciting
      gameplay features, and performance built on top of Airplane.
    '';
    homepage = "https://purpurmc.org/";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      yuannan
    ];
    mainProgram = "minecraft-server";
  };
})
