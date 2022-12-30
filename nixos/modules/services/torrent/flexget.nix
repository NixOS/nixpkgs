{ config, lib, pkgs, ... }:

let
  cfg = config.services.flexget;
  pkg = lib.getBin pkgs.flexget;
  fmt = pkgs.formats.yaml { };

  fileName = "flexget.yml";
  configFile =
    let
      t = fmt.generate "flexget-unchecked.yml"
        # use // instead of recursiveUpdate as we *want* to override schedules fully
        (cfg.settings // optionalAttrs (cfg.systemScheduler) { schedules = false; });
    in
    pkgs.runCommandLocal
      fileName
      { buildInputs = [ pkg ]; }
      ''
        install -Dm644 ${t} $out
        flexget -L DEBUG -c $out check
      '';

  inherit (lib)
    optionalAttrs replaceStrings
    mkRemovedOptionModule mkEnableOption mkOption mkIf types;

in
{
  imports = [
    (mkRemovedOptionModule [ "services" "flexget" "config" ] "Use services.flexget.settings instead")
  ];

  options.services.flexget = {
    enable = mkEnableOption (lib.mdDoc "Run FlexGet Daemon");

    user = mkOption {
      default = "deluge";
      example = "some_user";
      type = types.str;
      description = lib.mdDoc "The user under which to run flexget.";
    };

    homeDir = mkOption {
      default = "/var/lib/deluge";
      example = "/home/flexget";
      type = types.path;
      description = lib.mdDoc "Where files live.";
    };

    interval = mkOption {
      default = "10m";
      example = "1h";
      type = types.str;
      description = lib.mdDoc "When to perform a {command}`flexget` run. See {command}`man 7 systemd.time` for the format.";
    };

    systemScheduler = mkOption {
      default = true;
      example = false;
      type = types.bool;
      description = lib.mdDoc "When true, execute the runs via the flexget-runner.timer. If false, you have to specify the settings yourself in the YML file.";
    };

    settings = mkOption {
      default = { };
      type = fmt.type;
      description = lib.mdDoc "The configuration for FlexGet as an attribute set.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkg ];

    systemd.services = {
      flexget = {
        description = "FlexGet Daemon";
        path = [ pkg ];
        serviceConfig = {
          User = cfg.user;
          Environment = "TZ=${config.time.timeZone}";
          ExecStartPre = "${pkgs.coreutils}/bin/install -m644 ${configFile} ${cfg.homeDir}/${fileName}";
          ExecStart = "${pkg}/bin/flexget -c ./${fileName} daemon start";
          ExecStop = "${pkg}/bin/flexget -c ./${fileName} daemon stop";
          ExecReload = "${pkg}/bin/flexget -c ./${fileName} daemon reload";
          Restart = "on-failure";
          RestartSec = "2s";
          PrivateTmp = true;
          WorkingDirectory = cfg.homeDir;
        };
        wantedBy = [ "multi-user.target" ];
      };

      flexget-runner = mkIf cfg.systemScheduler {
        description = "FlexGet Runner";
        after = [ "flexget.service" ];
        wants = [ "flexget.service" ];
        serviceConfig = {
          User = cfg.user;
          ExecStart = "${pkg}/bin/flexget -c ./${fileName} execute";
          PrivateTmp = true;
          WorkingDirectory = cfg.homeDir;
        };
      };
    };

    systemd.timers.flexget-runner = mkIf cfg.systemScheduler {
      description = "Run FlexGet every ${cfg.interval}";
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnBootSec = cfg.interval;
        OnUnitInactiveSec = cfg.interval;
        Unit = "flexget-runner.service";
      };
    };
  };
}
