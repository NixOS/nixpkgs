{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.xserver.displayManager.startx;

in

{

  ###### interface

  options = {
    services.xserver.displayManager.startx = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable the dummy "startx" pseudo-display manager,
          which allows users to start X manually via the "startx" command
          from a vt shell. The X server runs under the user's id, not as root.
          The user must provide a ~/.xinitrc file containing session startup
          commands, see startx(1). This is not automatically generated
          from the desktopManager and windowManager settings.
        '';
      };
    };
  };


  ###### implementation

  config = mkIf cfg.enable {
    services.xserver = {
      exportConfiguration = true;
      displayManager.job.execCmd = "";
      displayManager.lightdm.enable = lib.mkForce false;
    };
    systemd.services.display-manager.enable = false;
    environment.systemPackages =  with pkgs; [ xorg.xinit ];
  };

}
