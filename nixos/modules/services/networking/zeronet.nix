{ config, pkgs, lib, nodes, ... }:
with lib;
let
  cfg = config.services.zeronet;

  ifNotNull = opt: s: if !isNull opt then s else "";

  configFile = builtins.toFile "zeronet.conf" ''
    [global]
    data_dir = ${cfg.dataDir}
    log_dir = ${cfg.logDir}
  ''
  + (ifNotNull cfg.uiIP
               "ui_ip = ${cfg.uiIp}")

  + (ifNotNull cfg.uiPort
               "ui_port = ${cfg.uiIp}")

  + (ifNotNull cfg.uiPw
               "ui_password = ${cfg.uiPw}")

  + (ifNotNull cfg.lang
               "language = ${cfg.lang}")

  + (ifNotNull cfg.uiRestrict
               "ui_restrict = ${cfg.uiRestrict}")

  + (ifNotNull cfg.uiHost
               "ui_host = ${cfg.uiHost}")

  + (ifNotNull cfg.homepage
               "homepage = ${cfg.homepage}")

  + (ifNotNull cfg.sizeLimit
               "size_limit = ${cfg.sizeLimit}")

  + (ifNotNull cfg.fileSizeLimit
               "file_size_limit = ${cfg.fileSizeLimit}")

  + (ifNotNull cfg.connectedLimit
               "connected_limit = ${cfg.connectedLimit}")

  + (ifNotNull cfg.workers
               "workers = ${cfg.workers}")

  + (ifNotNull cfg.bind
               "bind = ${cfg.bind}")

  + (ifNotNull cfg.maxFilesOpened
               "max_files_opened = ${cfg.maxFilesOpened}")

  + (ifNotNull cfg.stackSize
               "stack_size = ${cfg.stackSize}")

  + (ifNotNull cfg.useTempfiles
               "use_tempfiles = ${cfg.useTempfiles}")

  + cfg.extraConfig;

in
  {
    options = {
      services.zeronet = {
        enable = mkEnableOption "zeronet";

        user = mkOption {
          type = types.str;
          default = "zeronet";
          description = ''
          The user zeronoet should run as
          '';
        };

        group = mkOption {
          type = types.str;
          default = "zeronet";
          description = ''
          The group zeronet should run as
          '';
        };


        dataDir = mkOption {
          type = types.str;
          default = "/var/lib/zeronet";
          description = ''
          Path to the zeronet data directory
          '';
        };

        logDir = mkOption {
          type = types.str;
          default = "/var/log/zeronet";
          description = ''
          Path to the zeronet log directory
          '';
        };

        uiIP = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = ''
          The
          '';
        };

        uiPw = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = ''
          Password for the UI (Beware: This will be put into the /nix/store in
          plain text)
          '';
        };

        uiPort = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = ''
          '';
        };

        lang = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = ''
          '';
        };

        uiRestrict = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = ''
          '';
        };

        uiHost = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = ''
          '';
        };

        homepage = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = ''
          '';
        };

        sizeLimit = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = ''
          '';
        };

        fileSizeLimit = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = ''
          '';
        };

        connectedLimit = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = ''
          '';
        };

        workers = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = ''
          '';
        };

        bind = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = ''
          '';
        };

        maxFilesOpened = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = ''
          '';
        };

        stackSize = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = ''
          '';
        };

        useTempfiles = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = ''
          '';
        };

        extraConfig = mkOption {
          type = types.lines;
          default = "";
          description = ''
          Extra configuration to be appended to the zeronet config file
          '';
        };
      };
    };

    config = mkIf (cfg.enable) {
      users.users."${cfg.user}" = if cfg.user == "zeronet" then {
        isSystemUser = true;
        group = cfg.group;
        home = cfg.dataDir;
        createHome = true;
      } else {};

      users.groups."${cfg.group}" = {};

      systemd.services.zeronet = {
        enable = true;
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig.ExecStart  = "${pkgs.zeronet}/bin/zeronet.py --conf_file ${configFile}";
        serviceConfig.PrivateTmp = "yes";
        serviceConfig.User       = cfg.user;
        serviceConfig.Group      = cfg.group;

        preStart = ''
          mkdir -p ${cfg.dataDir}
          chown ${cfg.user}:${cfg.group} ${cfg.dataDir}

          mkdir -p ${cfg.logDir}
          chown ${cfg.user}:${cfg.group} ${cfg.logDir}
        '';

      };
    };
  }


