{ config, lib, pkgs, ... }:

let
  cfg = config.programs.ydotool;
in

{

  options = {
    programs.ydotool = {
      enable = lib.mkEnableOption (lib.mdDoc ''
        ydotool, a generic Linux command-line automation tool. Make sure to add your user to the input group:
        `users.users.alice.extraGroups = [ "input" ];`
      '');
    };
  };

  config = lib.mkIf cfg.enable {

    environment.systemPackages = [ pkgs.ydotool ];

    systemd.user.services.ydotoold = {
      description = "Starts ydotoold service";
      wantedBy = [ "default.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.ydotool}/bin/ydotoold";
        Restart = "always";
      };
    };
  };
}

