{
  lib,
  nix-update-script,
}:
{
  version = "1.15";
  maintainers = with lib.maintainers; [
    aanderse
    McSinyx
  ];
  updateScript = nix-update-script { };
}
