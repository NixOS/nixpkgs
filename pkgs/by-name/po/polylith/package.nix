{
  lib,
  stdenv,
  fetchurl,
  jdk,
  runtimeShell,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "polylith";
  version = "0.3.32";

  src = fetchurl {
    url = "https://github.com/polyfy/polylith/releases/download/v${finalAttrs.version}/poly-${finalAttrs.version}.jar";
    sha256 = "sha256-bfF7YXGA6StGF1jZor/TZQ6tNU28Z8kcaiPdkmjljx4=";
  };

  dontUnpack = true;

  passAsFile = [ "polyWrapper" ];
  polyWrapper = ''
    #!${runtimeShell}
    ARGS=""
    while [ "$1" != "" ] ; do
      ARGS="$ARGS $1"
      shift
    done
    exec "${jdk}/bin/java" "-jar" "${finalAttrs.src}" $ARGS
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp "$polyWrapperPath" $out/bin/poly
    chmod a+x $out/bin/poly

    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    $out/bin/poly help | fgrep -q '${finalAttrs.version}'

    runHook postInstallCheck
  '';

  meta = {
    description = "Tool used to develop Polylith based architectures in Clojure";
    mainProgram = "poly";
    homepage = "https://github.com/polyfy/polylith";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.epl10;
    maintainers = with lib.maintainers; [
      ericdallo
      jlesquembre
    ];
    platforms = jdk.meta.platforms;
  };
})
