{ config, pkgs, lib, ... }:

let
  cfg = config.services.xserver.displayManager.cosmic-greeter;
in
{
  meta.maintainers = with lib.maintainers; [ nyanbinary ];

  options.services.xserver.displayManager.cosmic-greeter = {
    enable = lib.mkEnableOption (lib.mdDoc "COSMIC greeter");
  };

  config = lib.mkIf cfg.enable {
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          user = "cosmic-greeter";
          command = "${pkgs.coreutils}/bin/env XCURSOR_THEME=Pop systemd-cat -t cosmic-greeter ${pkgs.cosmic-comp}/bin/cosmic-comp ${pkgs.cosmic-greeter}/bin/cosmic-greeter";
        };
      };
    };

    systemd.services.cosmic-greeter-daemon = {
      wantedBy = [ "multi-user.target" ];
      before = [ "greetd.service" ];
      serviceConfig = {
        ExecStart = "${pkgs.cosmic-greeter}/bin/cosmic-greeter-daemon";
        Restart = "on-failure";
      };
    };

    systemd.tmpfiles.rules = [
      "d '/var/lib/cosmic-greeter' - cosmic-greeter cosmic-greeter - -"
    ];

    users.users.cosmic-greeter = {
      isSystemUser = true;
      home = "/var/lib/cosmic-greeter";
      group = "cosmic-greeter";
    };

    users.groups.cosmic-greeter = { };

    hardware.opengl.enable = true;
    services.xserver.libinput.enable = true;

    security.pam.services.cosmic-greeter = { };

    services.dbus.packages = with pkgs; [ cosmic-greeter ];
  };
}
