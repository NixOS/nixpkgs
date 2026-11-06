{
  lib,
  stdenvNoCC,
  fetchurl,
  writeTextFile,
  autoPatchelfHook,
  jdk,
  isabelle,
}:

stdenvNoCC.mkDerivation (
  finalAttrs:
  let
    inherit (stdenvNoCC.hostPlatform) isDarwin isAarch64 extensions;

    settings = writeTextFile {
      name = "flatlaf-settings";
      text = ''
        ISABELLE_FLATLAF_HOME=@out@

        classpath "$ISABELLE_FLATLAF_HOME/share/java/flatlaf-${finalAttrs.version}-no-natives.jar:$ISABELLE_FLATLAF_HOME/share/java/flatlaf-extras-${finalAttrs.version}.jar"

        isabelle_scala_service "isabelle.FlatLightLaf"
        isabelle_scala_service "isabelle.FlatDarkLaf"
        isabelle_scala_service "isabelle.FlatMacLightLaf"
        isabelle_scala_service "isabelle.FlatMacDarkLaf"
      '';
    };

    nativeLibrary = "flatlaf-${finalAttrs.version}-${if isDarwin then "macos" else "linux"}-${
      if isAarch64 then "arm64" else "x86_64"
    }${extensions.sharedLibrary}";
  in
  {
    pname = "flatlaf";
    version = "3.6.2";

    outputs = [
      "out"
      "settings"
    ];

    src = fetchurl {
      url = "https://isabelle.in.tum.de/components/flatlaf-${finalAttrs.version}.tar.gz";
      hash = "sha256-em1UhYwcg6/mXo4a+FrRgb56SEy9rTlKEQ+jU9ENUD4=";
    };

    nativeBuildInputs = lib.optionals (!isDarwin) [
      autoPatchelfHook
    ];

    buildInputs = [
      jdk
    ];

    installPhase = ''
      runHook preInstall

      mkdir -p $out/share/java
      cp lib/*.jar $out/share/java
      cp lib/${nativeLibrary} $out/share/java

      mkdir -p $settings/etc
      substitute ${settings} $settings/etc/settings \
        --replace-fail '@out@' "$out"

      runHook postInstall
    '';

    preFixup = lib.optionalString (!isDarwin) ''
      addAutoPatchelfSearchPath ${jdk}/lib/openjdk/lib/
    '';

    meta = {
      description = "Swing Look and Feel";
      homepage = "https://www.formdev.com/flatlaf";
      sourceProvenance = with lib.sourceTypes; [
        binaryNativeCode
        binaryBytecode
      ];
      license = lib.licenses.asl20;
      maintainers = [ lib.maintainers.sempiternal-aurora ];
      platforms = isabelle.meta.platforms;
    };
  }
)
