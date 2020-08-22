{ config, lib, pkgs, ... }:

with lib;
let cfg = config.services.espanso;
in {
  meta = { maintainers = with lib.maintainers; [ numkem ]; };

  options = {
    services.espanso = { enable = options.mkEnableOption "Espanso"; };
  };

  config = mkIf cfg.enable {
    systemd.user.services.espanso = {
      description = "Espanso daemon";
      path = with pkgs; [ espanso libnotify xclip ];
      serviceConfig = {
        ExecStart = "${pkgs.espanso}/bin/espanso daemon";
        Restart = "on-failure";
      };
      wantedBy = [ "default.target" ];
    };

    environment.systemPackages = [ pkgs.espanso ];
  };
}
