# This module manages the terminfo database
# and its integration in the system.
{ config, lib, pkgs, ... }:

with lib;

{

  options.environment.enableAllTerminfo = with lib; mkOption {
    default = false;
    type = types.bool;
    description = lib.mdDoc ''
      Whether to install all terminfo outputs
    '';
  };

  config = {

<<<<<<< HEAD
    # can be generated with:
    # attrNames (filterAttrs
    #  (_: drv: (builtins.tryEval (isDerivation drv && drv ? terminfo)).value)
    #  pkgs)
    environment.systemPackages = mkIf config.environment.enableAllTerminfo (map (x: x.terminfo) (with pkgs; [
      alacritty
      contour
      foot
      kitty
      mtm
      rio
      rxvt-unicode-unwrapped
      rxvt-unicode-unwrapped-emoji
      st
      termite
      tmux
      wezterm
      yaft
=======
    # can be generated with: filter (drv: (builtins.tryEval (drv ? terminfo)).value) (attrValues pkgs)
    environment.systemPackages = mkIf config.environment.enableAllTerminfo (map (x: x.terminfo) (with pkgs; [
      alacritty
      foot
      kitty
      mtm
      rxvt-unicode-unwrapped
      rxvt-unicode-unwrapped-emoji
      termite
      wezterm
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    ]));

    environment.pathsToLink = [
      "/share/terminfo"
    ];

    environment.etc.terminfo = {
      source = "${config.system.path}/share/terminfo";
    };

    environment.profileRelativeSessionVariables = {
      TERMINFO_DIRS = [ "/share/terminfo" ];
    };

    environment.extraInit = ''

      # reset TERM with new TERMINFO available (if any)
      export TERM=$TERM
    '';

    security.sudo.extraConfig = ''

      # Keep terminfo database for root and %wheel.
      Defaults:root,%wheel env_keep+=TERMINFO_DIRS
      Defaults:root,%wheel env_keep+=TERMINFO
    '';

  };
}
