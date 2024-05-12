# Configuration for the xfs_quota command

{ config, lib, pkgs, ... }:

let

  cfg = config.programs.xfs_quota;

  limitOptions = opts: builtins.concatStringsSep " " [
    (lib.optionalString (opts.sizeSoftLimit != null) "bsoft=${opts.sizeSoftLimit}")
    (lib.optionalString (opts.sizeHardLimit != null) "bhard=${opts.sizeHardLimit}")
  ];

in

{

  ###### interface

  options = {

    programs.xfs_quota = {
      projects = lib.mkOption {
        default = {};
        type = lib.types.attrsOf (lib.types.submodule {
          options = {
            id = lib.mkOption {
              type = lib.types.int;
              description = "Project ID.";
            };

            fileSystem = lib.mkOption {
              type = lib.types.str;
              description = "XFS filesystem hosting the xfs_quota project.";
              default = "/";
            };

            path = lib.mkOption {
              type = lib.types.str;
              description = "Project directory.";
            };

            sizeSoftLimit = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              example = "30g";
              description = "Soft limit of the project size";
            };

            sizeHardLimit = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              example = "50g";
              description = "Hard limit of the project size.";
            };
          };
        });

        description = "Setup of xfs_quota projects. Make sure the filesystem is mounted with the pquota option.";

        example = {
          projname = {
            id = 50;
            path = "/xfsprojects/projname";
            sizeHardLimit = "50g";
          };
        };
      };
    };

  };


  ###### implementation

  config = lib.mkIf (cfg.projects != {}) {

    environment.etc.projects.source = pkgs.writeText "etc-project"
      (builtins.concatStringsSep "\n" (lib.mapAttrsToList
        (name: opts: "${builtins.toString opts.id}:${opts.path}") cfg.projects));

    environment.etc.projid.source = pkgs.writeText "etc-projid"
      (builtins.concatStringsSep "\n" (lib.mapAttrsToList
        (name: opts: "${name}:${builtins.toString opts.id}") cfg.projects));

    systemd.services = lib.mapAttrs' (name: opts:
      lib.nameValuePair "xfs_quota-${name}" {
        description = "Setup xfs_quota for project ${name}";
        script = ''
          ${pkgs.xfsprogs.bin}/bin/xfs_quota -x -c 'project -s ${name}' ${opts.fileSystem}
          ${pkgs.xfsprogs.bin}/bin/xfs_quota -x -c 'limit -p ${limitOptions opts} ${name}' ${opts.fileSystem}
        '';

        wantedBy = [ "multi-user.target" ];
        after = [ ((builtins.replaceStrings [ "/" ] [ "-" ] opts.fileSystem) + ".mount") ];

        restartTriggers = [ config.environment.etc.projects.source ];

        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
        };
      }
    ) cfg.projects;

  };

}
