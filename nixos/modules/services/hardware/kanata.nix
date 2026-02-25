{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.kanata;
in
{
  options.services.kanata = {
    enable = lib.mkEnableOption "kanata, a tool to improve keyboard comfort and usability with advanced customization";
  };

  config = lib.mkIf cfg.enable {
    system.services.kanata = {
      imports = [ pkgs.kanata.services.default ];
    };

    hardware.uinput.enable = true;
  };

  meta.maintainers = with lib.maintainers; [ linj ];
}
