# This file defines the options that can be used both for the Nginx
# main server configuration, and for the virtual hosts.  (The latter
# has additional options that affect the web server as a whole, like
# the user/group to run under.)

{ lib, ... }:

with lib;
{
  options = {
    serverAliases = mkOption {
      type = types.listOf types.str;
      default = [ ];
      example = [ "www.example.org" "example.org" ];
      description = ''
        Additional names of virtual hosts served by this virtual host configuration.
      '';
    };

    extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = ''
        These lines go into the vhost verbatim
      '';
    };
  };
}
