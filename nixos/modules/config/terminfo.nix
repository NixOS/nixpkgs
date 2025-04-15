# This module manages the terminfo database
# and its integration in the system.
{
  config,
  lib,
  pkgs,
  ...
}:
{

  options = with lib; {
    environment.enableAllTerminfo = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = ''
        Whether to install all terminfo outputs
      '';
    };

    security.sudo.keepTerminfo = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = ''
        Whether to preserve the `TERMINFO` and `TERMINFO_DIRS`
        environment variables, for `root` and the `wheel` group.
      '';
    };
  };

  config = {

    # This should not contain packages that are broken or can't build, since it
    # will break this expression
    #
    # can be generated with:
    # lib.attrNames (lib.filterAttrs
    #  (_: drv: (builtins.tryEval (lib.isDerivation drv && drv ? terminfo)).value)
    #  pkgs)
    environment.systemPackages = lib.mkIf config.environment.enableAllTerminfo (
      map (x: x.terminfo) (
        with pkgs.pkgsBuildBuild;
        [
          alacritty
          contour
          foot
          ghostty
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
        ]
      )
    );

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

    security =
      let
        extraConfig = ''

          # Keep terminfo database for root and %wheel.
          Defaults:root,%wheel env_keep+=TERMINFO_DIRS
          Defaults:root,%wheel env_keep+=TERMINFO
        '';
      in
      lib.mkIf config.security.sudo.keepTerminfo {
        sudo = { inherit extraConfig; };
        sudo-rs = { inherit extraConfig; };
      };
  };
}
