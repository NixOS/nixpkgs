# This file defines the options that can be used both for the Apache
# main server configuration, and for the virtual hosts.  (The latter
# has additional options that affect the web server as a whole, like
# the user/group to run under.)

{ lib }:

with lib;

{
  options = {
    proxyPass = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "http://www.example.org/";
      description = ''
        Adds proxy_pass directive and sets default proxy headers Host, X-Real-Ip
        and X-Forwarded-For.
      '';
    };

    root = mkOption {
      type = types.nullOr types.path;
      default = null;
      example = /your/root/directory;
      description = ''
        Root directory for requests.
      '';
    };
  };
}

