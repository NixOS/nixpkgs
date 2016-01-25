{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.sanoid;

  makeConfigPart = name: cfg:
  ''
    [${name}]
    ${optionalString (cfg.useTemplate != null) "use_template=${cfg.useTemplate}"}
    ${optionalString (cfg.hourly != null) "hourly=${toString cfg.hourly}"}
    ${optionalString (cfg.daily != null) "daily=${toString cfg.daily}"}
    ${optionalString (cfg.monthly != null) "monthly=${toString cfg.monthly}"}
    ${optionalString (cfg.yearly != null) "yearly=${toString cfg.yearly}"}
    ${optionalString (cfg.recursive == true) "recursive=yes"}
    ${optionalString (cfg.recursive == false) "recursive=no"}
    ${optionalString (cfg.processChildrenOnly == true) "process_children_only=yes"}
    ${optionalString (cfg.processChildrenOnly == false) "process_children_only=no"}
    ${optionalString (cfg.autosnap == true) "autosnap=yes"}
    ${optionalString (cfg.autosnap == false) "autosnap=no"}
    ${optionalString (cfg.autoprune == true) "autoprune=yes"}
    ${optionalString (cfg.autoprune == false) "autoprune=no"}
  '';
in
{
  options = {
    services.sanoid = {
      enable = mkEnableOption "Enable periodic Sanoid runs.";

      period = mkOption {
        type = types.str;
        default = "* * * * *";
        description = ''
          Cron period to run Sanoid at.
        '';
      };

      datasets = mkOption {
        type = types.attrsOf (types.submodule (
          {
            options = {
              hourly = mkOption {
                type = types.nullOr types.int;
                default = null;
                description = ''
                  Number of hourly snapshots to keep.
                '';
              };

              daily = mkOption {
                type = types.nullOr types.int;
                default = null;
                description = ''
                  Number of daily snapshots to keep.
                '';
              };

              monthly = mkOption {
                type = types.nullOr types.int;
                default = null;
                description = ''
                  Number of monthly snapshots to keep.
                '';
              };

              yearly = mkOption {
                type = types.nullOr types.int;
                default = null;
                description = ''
                  Number of yearly snapshots to keep.
                '';
              };

              autosnap = mkOption {
                type = types.nullOr types.bool;
                default = null;
                description = ''
                  Create snapshots automatically.
                '';
              };

              autoprune = mkOption {
                type = types.nullOr types.bool;
                default = null;
                description = ''
                  Prune old snapshots automatically.
                '';
              };

              recursive = mkOption {
                type = types.nullOr types.bool;
                default = false;
                description = ''
                  Perform recursive snapshots?
                '';
              };

              processChildrenOnly = mkOption {
                type = types.nullOr types.bool;
                default = false;
                description = ''
                  Process only children snapshots.
                '';
              };

              useTemplate = mkOption {
                type = types.nullOr types.str;
                default = null;
                description = ''
                  Name of template to use.
                '';
              };
            };
          }
        ));

        default = {};

        example = literalExample ''
          services.sanoid = {
            enable = true;
            datasets = {
              template_production = {
                hourly = 36;
                daily = 30;
                monthly = 3;
                yearly = 0;
                autoprune = true;
                autosnap = true;
              };
              "data/home" = {
                useTemplate = "prodution";
              };
              "data/images" = {
                useTemplate = "prodution";
                recursive = true;
                processChildrenOnly = true;
              };
              "data/images/win7" = {
                hourly = 4;
              };
            };
          };
        '';

        description = ''
          Policy-driven snapshot management and replication tools. Currently using ZFS
          for underlying next-gen storage, with explicit plans to support btrfs when
          btrfs becomes more reliable. Primarily intended for Linux, but BSD use is
          supported and reasonably frequently tested. http://www.openoid.net/products/
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    environment.etc.sanoidConf = {
      enable = true;
      target = "sanoid.conf";
      text = (concatStringsSep "\n\n" (mapAttrsToList (name: cfg: makeConfigPart name cfg) cfg.datasets));
    };

    environment.systemPackages = [ pkgs.sanoid pkgs.mbuffer ];

    systemd.services."sanoid-run" = {
      description = "Perform Sanoid run according to configuration.";
      requires    = [ "zfs.target" ];
      after       = [ "zfs.target" ];

      path = [ pkgs.sanoid pkgs.zfs ];

      script = ''
        sanoid --cron
      '';

      serviceConfig = {
        IOSchedulingClass = "idle";
        NoNewPrivileges = "true";
        CapabilityBoundingSet = "CAP_DAC_READ_SEARCH";
        PermissionsStartOnly = "true";
      };
    };

    systemd.timers.sanoid-run = {
      timerConfig.OnCalendar = "minutely";
      timerConfig.Persistent = "true";
      wantedBy = [ "timers.target" ];
    };
  };
}
