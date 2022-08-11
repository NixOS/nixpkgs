{config, lib, pkgs, ...}:

with lib;

let
  cfg = config.services.writefreely;
  configFile = pkgs.writeText "config.ini" (generators.toINI {} cfg.settings);
  settingsFormat = pkgs.formats.ini {};
in {
  options.services.writefreely = {
    enable = mkEnableOption "WriteFreely, a Markdown-based publishing platform.";

    package = mkOption {
      type = types.package;
      default = pkgs.writefreely;
      defaultText = literalExpression "pkgs.writefreely";
      description = lib.mdDoc ''
        Overridable attribute of the WriteFreely package to use.
      '';
    };

    user = mkOption {
      type = types.str;
      default = "writefreely";
      description = lib.mdDoc "User account under which writefreely runs.";
    };

    group = mkOption {
      type = types.str;
      default = "writefreely";
      description = lib.mdDoc "Group under which writefreely runs.";
    };

    dataDir = mkOption {
      default = "/var/lib/writefreely";
      type = types.path;
      description = lib.mdDoc "WriteFreely data directory.";
    };

    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = settingsFormat.type;
      };
      default = {};
      defaultText = ''
        {
          server = {
            templates_parent_dir = cfg.package;
            static_parent_dir = cfg.package;
            pages_parent_dir = cfg.package;

            keys_parent_dir = cfg.dataDir;
          };
          app = {
            theme = "write";
          };
        }
      '';
      description = lib.mdDoc ''
        Configuration for WriteFreely. See the
        [upstream documentation](https://writefreely.org/docs/latest/admin/config)
        for available options.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    services.writefreely.settings = {
      server = {
        templates_parent_dir = lib.mkDefault cfg.package;
        static_parent_dir = lib.mkDefault cfg.package;
        pages_parent_dir = lib.mkDefault cfg.package;
        keys_parent_dir = lib.mkDefault cfg.dataDir;
      };
      app = {
        theme = lib.mkDefault "write";
      };
    };

    systemd.services.writefreely = {
      description = lib.mdDoc "WriteFreely, a markdown based publishing platform";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;

        ExecStartPre = [
          "${cfg.package}/bin/writefreely -c ${configFile} --gen-keys"
          "${cfg.package}/bin/writefreely -c ${configFile} --init-db"
          "${cfg.package}/bin/writefreely -c ${configFile} --migrate"
        ];
        ExecStart = "${cfg.package}/bin/writefreely -c ${configFile}";
        Restart = "on-failure";

        WorkingDirectory = cfg.dataDir;
        StateDirectory = lib.mkIf
          (cfg.dataDir == "/var/lib/writefreely")
          "writefreely";
        ReadOnlyPaths = [cfg.package];
        ReadWritePaths = [cfg.dataDir];
        LimitNOFILE = "1048576";
        PrivateTmp = true;
        PrivateDevices = true;
        ProtectHome = true;
        ProtectSystem = "strict";
      };
    };

    users.users.${cfg.user} = {
      group = cfg.group;
      isSystemUser = true;
    };

    users.groups.${cfg.group} = {};
  };
}
