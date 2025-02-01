{ config, lib, pkgs, ... }:

{
  meta = {
    maintainers = lib.teams.pantheon.members;
  };

  ###### interface
  options = {
    programs.pantheon-tweaks.enable = lib.mkEnableOption "Pantheon Tweaks, an unofficial system settings panel for Pantheon";
  };

  ###### implementation
  config = lib.mkIf config.programs.pantheon-tweaks.enable {
    services.xserver.desktopManager.pantheon.extraSwitchboardPlugs = [ pkgs.pantheon-tweaks ];
  };
}
