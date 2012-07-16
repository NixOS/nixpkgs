# This module creates /etc/shells, the file that defines the list of
# permissible login shells for user accounts.

{ config, pkgs, ... }:

with pkgs.lib;

{

  config = {

    environment.etc = singleton
      { target = "shells";
        source = pkgs.writeText "shells"
          ''
            /run/current-system/sw/bin/bash
            /var/run/current-system/sw/bin/bash
            /bin/sh
          '';
      };

  };

}
