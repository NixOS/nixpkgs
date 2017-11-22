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

  + (ifNotNull cfg.fileserverIp
               "fileserver_ip = ${cfg.fileserverIp}")

  + (ifNotNull cfg.fileserverPort
               "fileserver_port = ${cfg.fileserverPort}")

  + (ifNotNull cfg.ipLocal
               "ip_local = ${cfg.IpLocal}")

  + (ifNotNull cfg.disableUdp
               "disable_udp = true")

  + (ifNotNull cfg.proxy
               "proxy = ${cfg.proxy}")

  + (ifNotNull cfg.bind
               "bind = ${cfg.bind}")

  + (ifNotNull cfg.ipExternal
               "ip_external = ${cfg.ipExternal}")

  + (ifNotNull cfg.trackers
               "trackers = ${cfg.trackers}")

  + (ifNotNull cfg.trackersFile
               "trackers_file = ${cfg.trackersFile}")

  + (ifNotNull cfg.useOpenssl
               "use_openssl = ${cfg.useOpenssl}")

  + (ifNotNull cfg.disableDb
               "disable_db = ${cfg.disableDb}")

  + (ifNotNull cfg.disableEncryption
               "disable_encryption = ${xdf.disableEncryption}")

  + (ifNotNull cfg.disableSslcompression
               "disable_sslcompression = ${cfg.disableSslcompression}")

  + (ifNotNull cfg.keepSslCert
               "keep_ssl_cert = ${cfg.keepSslCert}")

  + (ifNotNull cfg.maxFilesOpened
               "max_files_opened = ${cfg.maxFilesOpened}")

  + (ifNotNull cfg.stackSize
               "stack_size = ${cfg.stackSize}")

  + (ifNotNull cfg.useTempfiles
               "use_tempfiles = ${cfg.useTempfiles}")

  + (ifNotNull cfg.streamDownloads
               "stream_downloads = ${cfg.streamDownloads}")

  + (ifNotNull cfg.msgpackPurepython
               "msgpack_purepython = ${cfg.msgpackPurepython}")

  + (ifNotNull cfg.fixFloatDecimals
               "fix_float_decimals = ${cfg.fixFloatDecimals}")

  + (ifNotNull cfg.dbMode
               "db_mode = ${cfg.dbMode}")

  + (ifNotNull cfg.downloadOptional
               "download_optional = ${cfg.downloadOptional}")

  + (ifNotNull cfg.coffeescriptCompiler
               "coffeescript_compiler = ${cfg.coffeescriptCompiler}")

  + (ifNotNull cfg.tor
               "tor = ${cfg.tor}")

  + (ifNotNull cfg.torController
               "tor_controller = ${cfg.torController}")

  + (ifNotNull cfg.torProxy
               "tor_proxy = ${cfg.torProxy}")

  + (ifNotNull cfg.torPassword
               "tor_password = ${cfg.torPassword}")

  + (ifNotNull cfg.torHsLimit
               "tor_hs_limit = ${cfg.torHsLimit}")

  + (ifNotNull cfg.bitResolver
               "bit_resolver = ${cfg.bitResolver}")

  + (ifNotNull cfg.optionalLimit
               "optional_limit = ${cfg.optionalLimit}")

  + (ifNotNull cfg.pinBigfile
               "pin_bigfile = ${cfg.pinBigfile}")

  + (ifNotNull cfg.autodownloadBigfileSizeLimit
               "autodownload_bigfile_size_limit = ${cfg.autodownloadBigfileSizeLimit}")

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

        fileserverIp = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = ''
          '';
        };

        fileserverPort = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = ''
          '';
        };

        ipLocal = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = ''
          '';
        };

        disableUdp = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = ''
          '';
        };

        proxy = mkOption {
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

        ipExternal = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = ''
          '';
        };

        trackers = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = ''
          '';
        };

        trackersFile = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = ''
          '';
        };

        useOpenssl = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = ''
          '';
        };

        disableDb = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = ''
          '';
        };

        disableEncryption = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = ''
          '';
        };

        disableSslcompression = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = ''
          '';
        };

        keepSslCert = mkOption {
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

        streamDownloads = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = ''
          '';
        };

        msgpackPurepython = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = ''
          '';
        };

        fixFloatDecimals = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = ''
          '';
        };

        dbMode = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = ''
          '';
        };

        downloadOptional = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = ''
          '';
        };

        coffeescriptCompiler = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = ''
          '';
        };

        tor = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = ''
          '';
        };

        torController = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = ''
          '';
        };

        torProxy = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = ''
          '';
        };

        torPassword = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = ''
          '';
        };

        torHsLimit = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = ''
          '';
        };

        bitResolver = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = ''
          '';
        };

        optionalLimit = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = ''
          '';
        };

        pinBigfile = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = ''
          '';
        };

        autodownloadBigfileSizeLimit = mkOption {
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


