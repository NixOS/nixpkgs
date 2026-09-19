{
  lib,
  stdenvNoCC,
  fetchurl,
  makeWrapper,
  jre,
}:

stdenvNoCC.mkDerivation rec {
  pname = "bluemap";
  version = "5.27";

  src = fetchurl {
    url = "https://github.com/BlueMap-Minecraft/BlueMap/releases/download/v${version}/BlueMap-${version}-cli.jar";
    hash = "sha256-0eo/q2reTIizDPeU+AgqH+UA86JGlX62nKqUtu5dRO0=";
  };

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    makeWrapper ${jre}/bin/java $out/bin/bluemap --add-flags "-jar $src"
    runHook postInstall
  '';

  meta = {
    description = "3D minecraft map renderer";
    homepage = "https://bluemap.bluecolored.de/";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      dandellion
      h7x4
    ];
    mainProgram = "bluemap";
  };
}
