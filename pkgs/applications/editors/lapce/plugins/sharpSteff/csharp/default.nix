{ lapce-utils, lib }:

lapce-utils.pluginFromRegistry {
  author = "sharpSteff";
  name = "csharp";
  version = "2.0.0";
  hash = "sha256-2wa11YRRSQVEXHkVQch1lsIVmoiHh1KMFTi2HeQAv2g=";
  meta = {
    description = "C# for lapce using csharp-ls";
    homepage = "https://plugins.lapce.dev/plugins/sharpSteff/csharp";
    maintainers = with lib.maintainers; [ timon-schelling ];
    license = with lib.licenses; [ unfreeRedistributable ];
  };
}
