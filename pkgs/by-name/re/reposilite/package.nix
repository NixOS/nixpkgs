{ stdenv, lib, fetchurl, makeWrapper, jre_headless }:

stdenv.mkDerivation (finalAttrs: {
  pname = "Reposilite";
  version = "3.5.14";

  src = fetchurl {
    url = "https://maven.reposilite.com/releases/com/reposilite/reposilite/${finalAttrs.version}/reposilite-${finalAttrs.version}-all.jar";
    hash = "sha256-qZXYpz6SBXDBj8c0IZkfVgxEFe/+DxMpdhLJsjks8cM=";
  };

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib
    cp $src $out/lib/reposilite
    makeWrapper ${jre_headless}/bin/java $out/bin/reposilite \
      --add-flags "-Xmx40m -jar $out/lib/reposilite"

    runHook postInstall
  '';

  meta = {
    description = "Lightweight and easy-to-use repository management software dedicated for the Maven based artifacts in the JVM ecosystem";
    homepage = "https://github.com/dzikoysk/reposilite";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jamalam ];
    inherit (jre_headless.meta) platforms;
    mainProgram = "reposilite";
  };
})
