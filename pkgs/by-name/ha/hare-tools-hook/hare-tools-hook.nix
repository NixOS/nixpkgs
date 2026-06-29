{
  hareHook,
  makeSetupHook,
  lib,
}:

makeSetupHook {
  name = "hare-tools-hook";
  propagatedBuildInputs = [ hareHook ];
  meta = {
    description = "Setup hook for the Hare tools";
    maintainers = with lib.maintainers; [ snifexx ];
    inherit (hareHook.meta) badPlatforms platforms;
  };
} ./hare-tools-hook.sh
