{ config, lib, pkgs, ... }:

{
  options = {

    services.xray = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to run xray server.

          Either `settingsFile` or `settings` must be specified.
        '';
      };

      package = lib.mkPackageOption pkgs "xray" { };

      settingsFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        example = "/etc/xray/config.json";
        description = ''
          The absolute path to the configuration file.

          Either `settingsFile` or `settings` must be specified.

          See <https://www.v2fly.org/en_US/config/overview.html>.
        '';
      };

      settings = lib.mkOption {
        type = lib.types.nullOr (lib.types.attrsOf lib.types.unspecified);
        default = null;
        example = {
          inbounds = [{
            port = 1080;
            listen = "127.0.0.1";
            protocol = "http";
          }];
          outbounds = [{
            protocol = "freedom";
          }];
        };
        description = ''
          The configuration object.

          Either `settingsFile` or `settings` must be specified.

          See <https://www.v2fly.org/en_US/config/overview.html>.
        '';
      };
    };

  };

  config = let
    cfg = config.services.xray;
    settingsFile = if cfg.settingsFile != null
      then cfg.settingsFile
      else pkgs.writeTextFile {
        name = "xray.json";
        text = builtins.toJSON cfg.settings;
        checkPhase = ''
          ${cfg.package}/bin/xray -test -config $out
        '';
      };

  in lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = (cfg.settingsFile == null) != (cfg.settings == null);
        message = "Either but not both `settingsFile` and `settings` should be specified for xray.";
      }
    ];

    systemd.services.xray = {
      description = "xray Daemon";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        DynamicUser = true;
        ExecStart = "${cfg.package}/bin/xray -config ${settingsFile}";
        CapabilityBoundingSet = "CAP_NET_ADMIN CAP_NET_BIND_SERVICE";
        AmbientCapabilities = "CAP_NET_ADMIN CAP_NET_BIND_SERVICE";
        NoNewPrivileges = true;
      };
    };
  };
}
