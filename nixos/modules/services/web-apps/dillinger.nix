{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.dillinger;
in {
  options.services.dillinger = {
    enable = mkEnableOption "dillinger";

    listenAddress = mkOption {
      type = types.str;
      default = "localhost";
      description = ''
        Address dillinger should listen on
      '';
    };

    port = mkOption {
      type = types.int;
      default = 8080;
      example = 2342;
      description = ''
        Port dillinger should listen on
      '';
    };

    user = mkOption {
      type  = types.nullOr types.str;
      default = "nobody";
      example = "root";
      description = ''
        User under which the dillinger service runs
      '';
    };

    extraEnv = mkOption {
      type = types.attrsOf types.str;
      default = {};
      example = {
        github_client_id = "YOUR_KEY";
        github_client_secret = "YOUR_SECRET";
        github_callback_url= "YOUR_CALLBACK_URL";
        github_redirect_uri = "YOUR_REDIRECT_URI";
      };
      description = ''
        Extra environment variables that should be set.
        See the dillinger source repo for additional plugin configuration options
        (https://github.com/joemccann/dillinger#plugins)
      '';
    };
  };

  config = mkIf cfg.enable rec {
    systemd.services.dillinger = {
      description = "dillinger markdown editor";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      environment = mkMerge [{
        NODE_ENV = "production";
        BIND_ADDRESS = cfg.listenAddress;
        PORT = toString cfg.port;
      } cfg.extraEnv ];

      serviceConfig = {
        ExecStart = "${pkgs.dillinger}/bin/dillinger";
        User = cfg.user;
        RuntimeDirectory = "dillinger";
      };
    };
  };
}
