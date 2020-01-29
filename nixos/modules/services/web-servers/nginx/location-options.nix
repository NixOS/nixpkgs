# This file defines the options that can be used both for the Nginx
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
        Adds proxy_pass directive and sets recommended proxy headers if
        recommendedProxySettings is enabled.
      '';
    };

    proxyWebsockets = mkOption {
      type = types.bool;
      default = false;
      example = true;
      description = ''
        Whether to supporty proxying websocket connections with HTTP/1.1.
      '';
    };

    index = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "index.php index.html";
      description = ''
        Adds index directive.
      '';
    };

    tryFiles = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "$uri =404";
      description = ''
        Adds try_files directive.
      '';
    };

    root = mkOption {
      type = types.nullOr types.path;
      default = null;
      example = "/your/root/directory";
      description = ''
        Root directory for requests.
      '';
    };

    alias = mkOption {
      type = types.nullOr types.path;
      default = null;
      example = "/your/alias/directory";
      description = ''
        Alias directory for requests.
      '';
    };

    return = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "301 http://example.com$request_uri";
      description = ''
        Adds a return directive, for e.g. redirections.
      '';
    };

    extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = ''
        These lines go to the end of the location verbatim.
      '';
    };

    priority = mkOption {
      type = types.int;
      default = 1000;
      description = ''
        Order of this location block in relation to the others in the vhost.
        The semantics are the same as with `lib.mkOrder`. Smaller values have
        a greater priority.
      '';
    };
  };
}
