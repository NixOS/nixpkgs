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
    version = "1.0.1";
    src = fetchurl {
      url = "mirror://maven/io/prometheus/jmx/jmx_prometheus_javaagent/${finalAttrs.version}/${jarName}";
      hash = "sha256-fWH3N/1mFhDMwUrqeXZPqh6pSjQMvI8AKbPS7eo9gME=";
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
