{
  stdenvNoCC,
  fetchurl,
  writeTextFile,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "xz-java";
  version = "1.10";

  src = fetchurl {
    url = "https://isabelle.in.tum.de/components/xz-java-${finalAttrs.version}.tar.gz";
    hash = "sha256-4jXZVRB31g0uA9L6wP9hGqVzBPPSQ/tS+M9obxIVF0Q=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib
    cp lib/*.jar $out/lib

    runHook postInstall
  '';

  passthru.settings = writeTextFile {
    name = "xz-java-settings";
    text = ''
      ISABELLE_XZ_HOME="${finalAttrs.finalPackage}"

      classpath "$ISABELLE_XZ_HOME/lib/xz-1.10.jar"
    '';
    destination = "/etc/settings";
  };
})
