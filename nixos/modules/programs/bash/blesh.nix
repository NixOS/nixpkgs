{ lib, config, pkgs, ... }:
with lib;
let
  cfg = config.programs.bash.blesh;
in {
  options = {
    programs.bash.blesh.enable = mkEnableOption (mdDoc "blesh");
  };

  config = mkIf cfg.enable {
    programs.bash.interactiveShellInit = mkBefore ''
      source ${pkgs.blesh}/share/blesh/ble.sh
    '';
  };
  meta.maintainers = with maintainers; [ laalsaas ];
}
