# This module manages the terminfo database
# and its integration in the system.
{ config, ... }:
{
  config = {

    environment.pathsToLink = [
      "/share/terminfo"
    ];

    environment.etc."terminfo" = {
      source = "${config.system.path}/share/terminfo";
    };

    environment.profileRelativeEnvVars = {
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
