{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.railcar;
  generateUnit = name: containerConfig:
    let
      container = pkgs.ociTools.buildContainer {
        args = [
          (pkgs.writeShellScript "run.sh" containerConfig.cmd).outPath
        ];
      };
    in
      nameValuePair "railcar-${name}" {
        enable = true;
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
            ExecStart = ''
              ${cfg.package}/bin/railcar -r ${cfg.stateDir} run ${name} -b ${container}
            '';
            Type = containerConfig.runType;
          };
      };
  mount = with types; (submodule {
    options = {
      type = mkOption {
        type = str;
        default = "none";
        description = ''
          The type of the filesystem to be mounted.
          Linux: filesystem types supported by the kernel as listed in
          `/proc/filesystems` (e.g., "minix", "ext2", "ext3", "jfs", "xfs",
          "reiserfs", "msdos", "proc", "nfs", "iso9660"). For bind mounts
          (when options include either bind or rbind), the type is a dummy,
          often "none" (not listed in /proc/filesystems).
        '';
      };
      source = mkOption {
        type = str;
        description = "Source for the in-container mount";
      };
      options = mkOption {
        type = loaOf (str);
        default = [ "bind" ];
        description = ''
          Mount options of the filesystem to be used.

          Support optoions are listed in the mount(8) man page. Note that
          both filesystem-independent and filesystem-specific options
          are listed.
        '';
      };
    };
  });
in
{
  options.services.railcar = {
    enable = mkEnableOption "railcar";

    containers = mkOption {
      default = {};
      description = "Declarative container configuration";
      type = with types; loaOf (submodule ({ name, config, ... }: {
        options = {
          cmd = mkOption {
            type = types.lines;
            description = "Command or script to run inside the container";
          };

          mounts = mkOption {
            type = with types; attrsOf mount;
            default = {};
            description = ''
              A set of mounts inside the container.

              The defaults have been chosen for simple bindmounts, meaning
              that you only need to provide the "source" parameter.
            '';
            example = ''
              { "/data" = { source = "/var/lib/data"; }; }
            '';
          };

          runType = mkOption {
            type = types.str;
            default = "oneshot";
            description = "The systemd service run type";
          };

          os = mkOption {
            type = types.str;
            default = "linux";
            description = "OS type of the container";
          };

          arch = mkOption {
            type = types.str;
            default = "x86_64";
            description = "Computer architecture type of the container";
          };
        };
      }));
    };

    stateDir = mkOption {
      type = types.path;
      default = ''/var/railcar'';
      description = "Railcar persistent state directory";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.railcar;
      description = "Railcar package to use";
    };
  };

  config = mkIf cfg.enable {
    systemd.services = flip mapAttrs' cfg.containers (name: containerConfig:
      generateUnit name containerConfig
    );
  };
}

