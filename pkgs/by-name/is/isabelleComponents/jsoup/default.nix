{
  stdenvNoCC,
  fetchurl,
  writeTextFile,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "jsoup";
  version = "1.21.2";

  src = fetchurl {
    url = "https://isabelle.in.tum.de/components/jsoup-${finalAttrs.version}.tar.gz";
    hash = "sha256-53uE8jy0lWHtYKgK4hcmYiU8AMUwxyZf1kxuoi09Zqg=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib
    cp lib/*.jar $out/lib

    runHook postInstall
  '';

  passthru.settings = writeTextFile {
    name = "jsoup-settings";
    text = ''
      ISABELLE_JSOUP_HOME="${finalAttrs.finalPackage}"

      classpath "$ISABELLE_JSOUP_HOME/lib/jsoup-1.21.2.jar"
    '';
    destination = "/etc/settings";
  };
})
