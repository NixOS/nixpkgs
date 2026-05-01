{
  lib,
  config,
  pkgs,
  ...
}:

let
  inherit (lib)
    types
    mkDefault
    mkOption
    mkPackageOption
    ;

  json = pkgs.formats.json { };

  cfg = config.services.zenohd;

in
{
  options = {
    services.zenohd = {
      enable = lib.mkEnableOption "Zenoh daemon.";

      package = mkPackageOption pkgs "zenoh" { };

      settings = mkOption {
        description = ''
          Config options for `zenoh.json5` configuration file.

          See <https://github.com/eclipse-zenoh/zenoh/blob/main/DEFAULT_CONFIG.json5>
          for more information.
        '';
        default = { };
        type = types.submodule {
          freeformType = json.type;
        };
      };

      plugins = mkOption {
        description = "Plugin packages to add to zenohd search paths.";
        type = with types; listOf package;
        default = [ ];
        example = lib.literalExpression ''
          [ pkgs.zenoh-plugin-mqtt ]
        '';
      };

      backends = mkOption {
        description = "Storage backend packages to add to zenohd search paths.";
        type = with types; listOf package;
        default = [ ];
        example = lib.literalExpression ''
          [ pkgs.zenoh-backend-rocksdb ]
        '';
      };

      home = mkOption {
        description = "Base directory for zenohd related files defined via ZENOH_HOME.";
        type = types.str;
        default = "/var/lib/zenoh";
      };

      env = mkOption {
        description = ''
          Set environment variables consumed by zenohd and its plugins.
        '';
        type = with types; attrsOf str;
        default = { };
      };

      extraOptions = mkOption {
        description = "Extra command line options for zenohd.";
        type = with types; listOf str;
        default = [ ];
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.zenohd =
      let
        cfgFile = json.generate "zenohd.json" cfg.settings;

      in
      {
        wantedBy = [ "multi-user.target" ];
        wants = [ "network-online.target" ];
        after = [ "network-online.target" ];

        environment = cfg.env;

        serviceConfig = {
          Type = "simple";
          User = "zenohd";
          Group = "zenohd";
          ExecStart =
            "${lib.getExe cfg.package} -c ${cfgFile} " + (lib.concatStringsSep " " cfg.extraOptions);
        };
      };

    users = {
      users.zenohd = {
        description = "Zenoh daemon user";
        group = "zenohd";
        isSystemUser = true;
      };

      groups.zenohd = { };
    };

    services.zenohd = {
      env.ZENOH_HOME = cfg.home;

      settings = {
        plugins_loading = {
          enabled = mkDefault true;
          search_dirs = mkDefault (
            (map (x: "${lib.getLib x}/lib") cfg.plugins) ++ [ "${lib.getLib cfg.package}/lib" ]
          ); # needed for internal plugins
        };

        plugins.storage_manager.backend_search_dirs = mkDefault (
          map (x: "${lib.getLib x}/lib") cfg.backends
        );
      };
    };

    systemd.tmpfiles.rules = [ "d ${cfg.home} 750 zenohd zenohd -" ];
  };
}
