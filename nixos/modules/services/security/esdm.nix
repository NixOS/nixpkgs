{ lib, config, pkgs, ... }:

let
  cfg = config.services.esdm;
in
{
  options.services.esdm = {
    enable = lib.mkEnableOption (lib.mdDoc "ESDM service configuration");
    package = lib.mkPackageOption pkgs "esdm" { };
    serverEnable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = lib.mdDoc ''
        Enable option for ESDM server service. If serverEnable == false, then the esdm-server
        will not start. Also the subsequent services esdm-cuse-random, esdm-cuse-urandom
        and esdm-proc will not start as these have the entry Want=esdm-server.service.
      '';
    };
    cuseRandomEnable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = lib.mdDoc ''
        Enable option for ESDM cuse-random service. Determines if the esdm-cuse-random.service
        is started.
      '';
    };
    cuseUrandomEnable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = lib.mdDoc ''
        Enable option for ESDM cuse-urandom service. Determines if the esdm-cuse-urandom.service
        is started.
      '';
    };
    procEnable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = lib.mdDoc ''
        Enable option for ESDM proc service. Determines if the esdm-proc.service
        is started.
      '';
    };
    verbose = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = lib.mdDoc ''
        Enable verbose ExecStart for ESDM. If verbose == true, then the corresponding "ExecStart"
        values of the 4 aforementioned services are overwritten with the option
        for the highest verbosity.
      '';
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      ({
        systemd.packages = [ cfg.package ];
      })
      # It is necessary to set those options for these services to be started by systemd in NixOS
      (lib.mkIf cfg.serverEnable {
        systemd.services."esdm-server".wantedBy = [ "basic.target" ];
        systemd.services."esdm-server".serviceConfig = lib.mkIf cfg.verbose {
          ExecStart = [
            " " # unset previous value defined in 'esdm-server.service'
            "${cfg.package}/bin/esdm-server -f -vvvvvv"
          ];
        };
      })

      (lib.mkIf cfg.cuseRandomEnable {
        systemd.services."esdm-cuse-random".wantedBy = [ "basic.target" ];
        systemd.services."esdm-cuse-random".serviceConfig = lib.mkIf cfg.verbose {
          ExecStart = [
            " " # unset previous value defined in 'esdm-cuse-random.service'
            "${cfg.package}/bin/esdm-cuse-random -f -v 6"
          ];
        };
      })

      (lib.mkIf cfg.cuseUrandomEnable {
        systemd.services."esdm-cuse-urandom".wantedBy = [ "basic.target" ];
        systemd.services."esdm-cuse-urandom".serviceConfig = lib.mkIf cfg.verbose {
          ExecStart = [
            " " # unset previous value defined in 'esdm-cuse-urandom.service'
            "${config.services.esdm.package}/bin/esdm-cuse-urandom -f -v 6"
          ];
        };
      })

      (lib.mkIf cfg.procEnable {
        systemd.services."esdm-proc".wantedBy = [ "basic.target" ];
        systemd.services."esdm-proc".serviceConfig = lib.mkIf cfg.verbose {
          ExecStart = [
            " " # unset previous value defined in 'esdm-proc.service'
            "${cfg.package}/bin/esdm-proc --relabel -f -o allow_other /proc/sys/kernel/random -v 6"
          ];
        };
      })
    ]);

  meta.maintainers = with lib.maintainers; [ orichter thillux ];
}
