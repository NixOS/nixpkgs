{ config, lib, pkgs, ... }:

with lib;

let cfg = config.services.xserver.displayManager.sx;

in {
  options = {
    services.xserver.displayManager.sx = {
      enable = mkEnableOption "sx pseudo-display manager" // {
        description = ''
          Whether to enable the "sx" pseudo-display manager, which allows users
          to start manually via the "sx" command from a vt shell. The X server
          runs under the user's id, not as root. The user must provide a
          ~/.config/sx/sxrc file containing session startup commands, see
          sx(1). This is not automatically generated from the desktopManager
          and windowManager settings. sx doesn't have a way to directly set
          X server flags, but it can be done by overriding its xorgserver
          dependency.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.sx ];
    services.xserver = {
      exportConfiguration = true;
      logFile = mkDefault null;
    };
  };

  meta.maintainers = with maintainers; [ figsoda ];
}
