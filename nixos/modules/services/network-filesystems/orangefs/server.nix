{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.orangefs.server;

  aliases = lib.mapAttrsToList (alias: url: alias) cfg.servers;

  # Maximum handle number is 2^63
  maxHandle = 9223372036854775806;

  # One range of handles for each meta/data instance
  handleStep = maxHandle / (lib.length aliases) / 2;

  fileSystems = lib.mapAttrsToList (name: fs: ''
    <FileSystem>
      Name ${name}
      ID ${toString fs.id}
      RootHandle ${toString fs.rootHandle}

      ${fs.extraConfig}

      <MetaHandleRanges>
      ${lib.concatStringsSep "\n" (
        lib.imap0 (
          i: alias:
          let
            begin = i * handleStep + 3;
            end = begin + handleStep - 1;
          in
          "Range ${alias} ${toString begin}-${toString end}"
        ) aliases
      )}
      </MetaHandleRanges>

      <DataHandleRanges>
      ${lib.concatStringsSep "\n" (
        lib.imap0 (
          i: alias:
          let
            begin = i * handleStep + 3 + (lib.length aliases) * handleStep;
            end = begin + handleStep - 1;
          in
          "Range ${alias} ${toString begin}-${toString end}"
        ) aliases
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

    BMIModules ${lib.concatStringsSep "," cfg.BMIModules}
    ${cfg.extraDefaults}
    </Defaults>

    ${cfg.extraConfig}

    <Aliases>
    ${lib.concatStringsSep "\n" (lib.mapAttrsToList (alias: url: "Alias ${alias} ${url}") cfg.servers)}
    </Aliases>

    ${lib.concatStringsSep "\n" fileSystems}
  '';

in
{
  ###### interface

  options = {
    services.orangefs.server = {
      enable = lib.mkEnableOption "OrangeFS server";

      logType = lib.mkOption {
        type =
          with lib.types;
          enum [
            "file"
            "syslog"
          ];
        default = "syslog";
        description = "Destination for log messages.";
      };

      dataStorageSpace = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        example = "/data/storage";
        description = "Directory for data storage.";
      };

      metadataStorageSpace = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        example = "/data/meta";
        description = "Directory for meta data storage.";
      };

      BMIModules = lib.mkOption {
        type = with lib.types; listOf str;
        default = [ "bmi_tcp" ];
        example = [
          "bmi_tcp"
          "bmi_ib"
        ];
        description = "List of BMI modules to load.";
      };

      extraDefaults = lib.mkOption {
        type = lib.types.lines;
        default = "";
        description = "Extra config for `<Defaults>` section.";
      };

      extraConfig = lib.mkOption {
        type = lib.types.lines;
        default = "";
        description = "Extra config for the global section.";
      };

      servers = lib.mkOption {
        type = with lib.types; attrsOf lib.types.str;
        default = { };
        example = {
          node1 = "tcp://node1:3334";
          node2 = "tcp://node2:3334";
        };
        description = "URLs for storage server including port. The attribute names define the server alias.";
      };

      fileSystems = lib.mkOption {
        description = ''
          These options will create the `<FileSystem>` sections of config file.
        '';
        default = {
          orangefs = { };
        };
        example = lib.literalExpression ''
          {
            fs1 = {
              id = 101;
            };

            fs2 = {
              id = 102;
            };
          }
        '';
        type =
          with lib.types;
          attrsOf (
            submodule (
              { ... }:
              {
                options = {
                  id = lib.mkOption {
                    type = lib.types.int;
                    default = 1;
                    description = "File system ID (must be unique within configuration).";
                  };

                  rootHandle = lib.mkOption {
                    type = lib.types.int;
                    default = 3;
                    description = "File system root ID.";
                  };

                  extraConfig = lib.mkOption {
                    type = lib.types.lines;
                    default = "";
                    description = "Extra config for `<FileSystem>` section.";
                  };

                  troveSyncMeta = lib.mkOption {
                    type = lib.types.bool;
                    default = true;
                    description = "Sync meta data.";
                  };

                  troveSyncData = lib.mkOption {
                    type = lib.types.bool;
                    default = false;
                    description = "Sync data.";
                  };

                  extraStorageHints = lib.mkOption {
                    type = lib.types.lines;
                    default = "";
                    description = "Extra config for `<StorageHints>` section.";
                  };
                };
              }
            )
          );
      };
    };
  };

  ###### implementation

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.orangefs ];

    # orangefs daemon will run as user
    users.users.orangefs = {
      isSystemUser = true;
      group = "orangefs";
    };
    users.groups.orangefs = { };

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
        # Run as "simple" in foreground mode.
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
