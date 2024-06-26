{
  lib,
  stdenv,
  fetchurl,
}:
stdenv.mkDerivation (
  finalAttrs:
  let
    jarName = "jmx_prometheus_javaagent-${finalAttrs.version}.jar";
  in
  {
    pname = "jmx-prometheus-javaagent";
    version = "0.20.0";
    src = fetchurl {
      url = "mirror://maven/io/prometheus/jmx/jmx_prometheus_javaagent/${finalAttrs.version}/${jarName}";
      sha256 = "sha256-i2ftQEhdR1ZIw20R0hRktIRAb4X6+RKzNj9xpqeGEyA=";
    };

    dontUnpack = true;

    installPhase = ''
      env
      mkdir -p $out/lib
      cp $src $out/lib/${jarName}
    '';

    meta = {
      homepage = "https://github.com/prometheus/jmx_exporter";
      description = "A process for exposing JMX Beans via HTTP for Prometheus consumption";
      sourceProvenance = [ lib.sourceTypes.binaryBytecode ];
      license = lib.licenses.asl20;
      maintainers = [ lib.maintainers.srhb ];
      platforms = lib.platforms.unix;
    };
  }
)
