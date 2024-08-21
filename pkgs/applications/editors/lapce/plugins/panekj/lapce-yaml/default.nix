{ lapce-utils, lib }:

lapce-utils.pluginFromRegistry {
  author = "panekj";
  name = "lapce-yaml";
  version = "0.0.1";
  hash = "sha256-UV21phSBkZMKV4guArxedRgIB5nJlgcukbhmHDc/baU=";
  meta = {
    description = "YAML for Lapce: powered by yaml-language-server";
    homepage = "https://plugins.lapce.dev/plugins/panekj/lapce-yaml";
    maintainers = with lib.maintainers; [ timon-schelling ];
    license = with lib.licenses; [ unfreeRedistributable ];
  };
}
