{ config, lib, pkgs, ... }:

with lib;

{
  options = {

    services.xray = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Whether to run xray server.

          Either `settingsFile` or `settings` must be specified.
        '';
      };

      package = mkPackageOption pkgs "xray" { };

      settingsFile = mkOption {
        type = types.nullOr types.path;
        default = null;
        example = "/etc/xray/config.json";
        description = lib.mdDoc ''
          The absolute path to the configuration file.

          Either `settingsFile` or `settings` must be specified.

          See <https://www.v2fly.org/en_US/config/overview.html>.
        '';
      };

      settings = mkOption {
        type = types.nullOr (types.attrsOf types.unspecified);
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
        description = lib.mdDoc ''
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

  in mkIf cfg.enable {
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
