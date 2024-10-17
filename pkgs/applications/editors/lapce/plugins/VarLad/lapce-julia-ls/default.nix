{ lapce-utils, lib }:

lapce-utils.pluginFromRegistry {
  author = "VarLad";
  name = "lapce-julia-ls";
  version = "0.0.5";
  hash = "sha256-FGjDsNj4Z4q3GIwJysBgkE2ws/XQZYK2L7yMIuTkaUU=";
  meta = {
    description = "Julia plugin for the Lapce Editor - Powered by LanguageServer.jl";
    homepage = "https://plugins.lapce.dev/plugins/VarLad/lapce-julia-ls";
    maintainers = with lib.maintainers; [ timon-schelling ];
    license = with lib.licenses; [ unfreeRedistributable ];
  };
}
