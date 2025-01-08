# This file defines the options that can be used both for the Nginx
# main server configuration, and for the virtual hosts.  (The latter
# has additional options that affect the web server as a whole, like
# the user/group to run under.)

{ lib, config }:

{
  options = {
    basicAuth = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = {};
      example = lib.literalExpression ''
        {
          user = "password";
        };
      '';
      description = ''
        Basic Auth protection for a vhost.

        WARNING: This is implemented to store the password in plain text in the
        Nix store.
      '';
    };

    basicAuthFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = ''
        Basic Auth password file for a vhost.
        Can be created by running {command}`nix-shell --packages apacheHttpd --run 'htpasswd -B -c FILENAME USERNAME'`.
      '';
    };

    proxyPass = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      example = "http://www.example.org/";
      description = ''
        Adds proxy_pass directive and sets recommended proxy headers if
        recommendedProxySettings is enabled.
      '';
    };

    proxyWebsockets = lib.mkOption {
      type = lib.types.bool;
      default = false;
      example = true;
      description = ''
        Whether to support proxying websocket connections with HTTP/1.1.
      '';
    };

    index = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      example = "index.php index.html";
      description = ''
        Adds index directive.
      '';
    };

    tryFiles = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      example = "$uri =404";
      description = ''
        Adds try_files directive.
      '';
    };

    root = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      example = "/your/root/directory";
      description = ''
        Root directory for requests.
      '';
    };

    alias = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      example = "/your/alias/directory";
      description = ''
        Alias directory for requests.
      '';
    };

    return = lib.mkOption {
      type = with lib.types; nullOr (oneOf [ str int ]);
      default = null;
      example = "301 http://example.com$request_uri";
      description = ''
        Adds a return directive, for e.g. redirections.
      '';
    };

    fastcgiParams = lib.mkOption {
      type = lib.types.attrsOf (lib.types.either lib.types.str lib.types.path);
      default = {};
      description = ''
        FastCGI parameters to override.  Unlike in the Nginx
        configuration file, overriding only some default parameters
        won't unset the default values for other parameters.
      '';
    };

    extraConfig = lib.mkOption {
      type = lib.types.lines;
      default = "";
      description = ''
        These lines go to the end of the location verbatim.
      '';
    };

    priority = lib.mkOption {
      type = lib.types.int;
      default = 1000;
      description = ''
        Order of this location block in relation to the others in the vhost.
        The semantics are the same as with `lib.mkOrder`. Smaller values have
        a greater priority.
      '';
    };

    recommendedProxySettings = lib.mkOption {
      type = lib.types.bool;
      default = config.services.nginx.recommendedProxySettings;
      defaultText = lib.literalExpression "config.services.nginx.recommendedProxySettings";
      description = ''
        Enable recommended proxy settings.
      '';
    };
  };
}
