{ lib, config, pkgs, ... }:
with lib;
let
  cfg = config.programs.bash.blesh;
in {
  options = {
    programs.bash.blesh.enable = mkEnableOption "blesh, a full-featured line editor written in pure Bash";
  };

  config = mkIf cfg.enable {
    programs.bash.interactiveShellInit = mkBefore ''
      source ${pkgs.blesh}/share/blesh/ble.sh
    '';
  };
  meta.maintainers = with maintainers; [ laalsaas ];
}
