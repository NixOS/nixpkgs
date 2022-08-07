{ config, lib, pkgs, ...} :

with lib;

let
  cfg = config.services.orangefs.server;

  aliases = mapAttrsToList (alias: url: alias) cfg.servers;

  # Maximum handle number is 2^63
  maxHandle = 9223372036854775806;

  # One range of handles for each meta/data instance
  handleStep = maxHandle / (length aliases) / 2;

  fileSystems = mapAttrsToList (name: fs: ''
    <FileSystem>
      Name ${name}
      ID ${toString fs.id}
      RootHandle ${toString fs.rootHandle}

      ${fs.extraConfig}

      <MetaHandleRanges>
      ${concatStringsSep "\n" (
          imap0 (i: alias:
            let
              begin = i * handleStep + 3;
              end = begin + handleStep - 1;
            in "Range ${alias} ${toString begin}-${toString end}") aliases
       )}
      </MetaHandleRanges>

      <DataHandleRanges>
      ${concatStringsSep "\n" (
          imap0 (i: alias:
            let
              begin = i * handleStep + 3 + (length aliases) * handleStep;
              end = begin + handleStep - 1;
            in "Range ${alias} ${toString begin}-${toString end}") aliases
       )}
      </DataHandleRanges>

      <StorageHints>
      TroveSyncMeta ${if fs.troveSyncMeta then "yes" else "no"}
      TroveSyncData ${if fs.troveSyncData then "yes" else "no"}
      ${fs.extraStorageHints}
      </StorageHints>

    </FileSystem>
  '') cfg.fileSystems;

  configFile = ''
    <Defaults>
    LogType ${cfg.logType}
    DataStorageSpace ${cfg.dataStorageSpace}
    MetaDataStorageSpace ${cfg.metadataStorageSpace}

    BMIModules ${concatStringsSep "," cfg.BMIModules}
    ${cfg.extraDefaults}
    </Defaults>

    ${cfg.extraConfig}

    <Aliases>
    ${concatStringsSep "\n" (mapAttrsToList (alias: url: "Alias ${alias} ${url}") cfg.servers)}
    </Aliases>

    ${concatStringsSep "\n" fileSystems}
  '';

in {
  ###### interface

  options = {
    services.orangefs.server = {
      enable = mkEnableOption "OrangeFS server";

      logType = mkOption {
        type = with types; enum [ "file" "syslog" ];
        default = "syslog";
        description = lib.mdDoc "Destination for log messages.";
      };

      dataStorageSpace = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "/data/storage";
        description = lib.mdDoc "Directory for data storage.";
      };

      metadataStorageSpace = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "/data/meta";
        description = lib.mdDoc "Directory for meta data storage.";
      };

      BMIModules = mkOption {
        type = with types; listOf str;
        default = [ "bmi_tcp" ];
        example = [ "bmi_tcp" "bmi_ib"];
        description = lib.mdDoc "List of BMI modules to load.";
      };

      extraDefaults = mkOption {
        type = types.lines;
        default = "";
        description = lib.mdDoc "Extra config for `<Defaults>` section.";
      };

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = lib.mdDoc "Extra config for the global section.";
      };

      servers = mkOption {
        type = with types; attrsOf types.str;
        default = {};
        example = {
          node1 = "tcp://node1:3334";
          node2 = "tcp://node2:3334";
        };
        description = lib.mdDoc "URLs for storage server including port. The attribute names define the server alias.";
      };

      fileSystems = mkOption {
        description = lib.mdDoc ''
          These options will create the `<FileSystem>` sections of config file.
        '';
        default = { orangefs = {}; };
        example = literalExpression ''
          {
            fs1 = {
              id = 101;
            };

            fs2 = {
              id = 102;
            };
          }
        '';
        type = with types; attrsOf (submodule ({ ... } : {
          options = {
            id = mkOption {
              type = types.int;
              default = 1;
              description = lib.mdDoc "File system ID (must be unique within configuration).";
            };

            rootHandle = mkOption {
              type = types.int;
              default = 3;
              description = lib.mdDoc "File system root ID.";
            };

            extraConfig = mkOption {
              type = types.lines;
              default = "";
              description = lib.mdDoc "Extra config for `<FileSystem>` section.";
            };

            troveSyncMeta = mkOption {
              type = types.bool;
              default = true;
              description = lib.mdDoc "Sync meta data.";
            };

            troveSyncData = mkOption {
              type = types.bool;
              default = false;
              description = lib.mdDoc "Sync data.";
            };

            extraStorageHints = mkOption {
              type = types.lines;
              default = "";
              description = lib.mdDoc "Extra config for `<StorageHints>` section.";
            };
          };
        }));
      };
    };
  };

  ###### implementation

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.orangefs ];

    # orangefs daemon will run as user
    users.users.orangefs = {
      isSystemUser = true;
      group = "orangfs";
    };
    users.groups.orangefs = {};

    # To format the file system the config file is needed.
    environment.etc."orangefs/server.conf" = {
      text = configFile;
      user = "orangefs";
      group = "orangefs";
    };

    systemd.services.orangefs-server = {
      wantedBy = [ "multi-user.target" ];
      requires = [ "network-online.target" ];
      after = [ "network-online.target" ];

      serviceConfig = {
        # Run as "simple" in forground mode.
        # This is more reliable
        ExecStart = ''
          ${pkgs.orangefs}/bin/pvfs2-server -d \
            /etc/orangefs/server.conf
        '';
        TimeoutStopSec = "120";
        User = "orangefs";
        Group = "orangefs";
      };
    };
  };

}
