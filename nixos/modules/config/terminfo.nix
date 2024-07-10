# This module manages the terminfo database
# and its integration in the system.
{ config, lib, pkgs, ... }:

with lib;

{

  options = with lib; {
    environment.enableAllTerminfo = mkOption {
      default = false;
      type = types.bool;
      description = ''
        Whether to install all terminfo outputs
      '';
    };

    security.sudo.keepTerminfo = mkOption {
      default = true;
      type = types.bool;
      description = ''
        Whether to preserve the `TERMINFO` and `TERMINFO_DIRS`
        environment variables, for `root` and the `wheel` group.
      '';
    };
  };

  config = {

    # can be generated with:
    # attrNames (filterAttrs
    #  (_: drv: (builtins.tryEval (isDerivation drv && drv ? terminfo)).value)
    #  pkgs)
    environment.systemPackages = mkIf config.environment.enableAllTerminfo (map (x: x.terminfo) (with pkgs.pkgsBuildBuild; [
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

    security.sudo.extraConfig = mkIf config.security.sudo.keepTerminfo ''

      # Keep terminfo database for root and %wheel.
      Defaults:root,%wheel env_keep+=TERMINFO_DIRS
      Defaults:root,%wheel env_keep+=TERMINFO
    '';

  };
}
