{
  lib,
  makeGaugePlugin,
}:
makeGaugePlugin {
  pname = "xml-report";
  data = lib.importJSON ./data.json;

  repo = "getgauge/xml-report";
  releasePrefix = "xml-report-";

  meta = {
    description = "XML report generation plugin for Gauge";
    homepage = "https://github.com/getgauge/xml-report/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ marie ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    platforms = [
      "x86_64-darwin"
      "aarch64-darwin"
      "aarch64-linux"
      "x86_64-linux"
    ];
  };
}
