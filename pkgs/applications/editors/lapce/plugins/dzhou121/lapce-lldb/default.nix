{ lapce-utils, lib }:

lapce-utils.pluginFromRegistry {
  author = "dzhou121";
  name = "lapce-lldb";
  version = "0.1.1";
  hash = "sha256-pO1jjG6oOr1N7X/fmivJ3YnAjB/nSSbccMtuS92/y90=";
  meta = {
    description = "A debugger powered by LLDB.";
    homepage = "https://plugins.lapce.dev/plugins/dzhou121/lapce-lldb";
    maintainers = with lib.maintainers; [ timon-schelling ];
    license = with lib.licenses; [ unfreeRedistributable ];
  };
}
