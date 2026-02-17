{
  stdenvNoCC,
  lib,
  fetchzip,
  makeWrapper,
}:
stdenvNoCC.mkDerivation {
  pname = "roblox";
  version = "0.708.0.7080878";

  src = fetchzip {
    url = "https://setup.rbxcdn.com/mac${
      if (stdenvNoCC.hostPlatform.isAarch64) then "/arm64" else ""
    }/version-82324853106949ff-RobloxPlayer.zip";
    hash =
      if (stdenvNoCC.hostPlatform.isAarch64) then
        "sha256-YsT52clwVb+YIwFSB1h/GNxIRczM4mxTSk+kvhSEsGc="
      else
        "sha256-+22KpahSwN7z3tJ78Aoc2nrndCzKWUALWQoQxjPZ+IA=";
    stripRoot = false;
  };

  sourceRoot = ".";

  nativeBuildInputs = [
    makeWrapper
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -r $src/*.app $out/Applications

    runHook postInstall
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "A multiplayer block game platform designed for playing games";
    homepage = "https://www.roblox.com";
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ eveeifyeve ];
    mainProgram = "RobloxPlayer.app";
    platforms = lib.platforms.darwin;
  };
}
