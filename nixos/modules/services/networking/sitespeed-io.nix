{ lib, config, pkgs, ... }:
let
  cfg = config.services.sitespeed-io;
  format = pkgs.formats.json { };
in
{
  options.services.sitespeed-io = {
    enable = lib.mkEnableOption (lib.mdDoc "Sitespeed.io");

    user = lib.mkOption {
      type = lib.types.str;
      default = "sitespeed-io";
      description = lib.mdDoc "User account under which sitespeed-io runs.";
    };

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.sitespeed-io;
      defaultText = "pkgs.sitespeed-io";
      description = lib.mdDoc "Sitespeed.io package to use.";
    };

    dataDir = lib.mkOption {
      default = "/var/lib/sitespeed-io";
      type = lib.types.str;
      description = lib.mdDoc "The base sitespeed-io data directory.";
    };

    period = lib.mkOption {
      type = lib.types.str;
      default = "hourly";
      description = lib.mdDoc ''
        Systemd calendar expression when to run. See {manpage}`systemd.time(7)`.
      '';
    };

    runs = lib.mkOption {
      default = [ ];
      description = lib.mdDoc ''
        A list of run configurations. The service will call sitespeed-io once
        for every run listed here. This lets you examine different websites
        with different sitespeed-io settings.
      '';
      type = lib.types.listOf (lib.types.submodule {
        options = {
          urls = lib.mkOption {
            type = with lib.types; listOf str;
            default = [];
            description = lib.mdDoc ''
              URLs the service should monitor.
            '';
          };

          settings = lib.mkOption {
            type = lib.types.submodule {
              freeformType = format.type;
              options = { };
            };
            default = { };
            description = lib.mdDoc ''
              Configuration for sitespeed-io, see
              <https://www.sitespeed.io/documentation/sitespeed.io/configuration/>
              for available options. The value here will be directly transformed to
              JSON and passed as `--config` to the program.
            '';
          };

          extraArgs = lib.mkOption {
            type = with lib.types; listOf str;
            default = [];
            description = lib.mdDoc ''
              Extra command line arguments to pass to the program.
            '';
          };
        };
      });
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
    {
      assertion = cfg.runs != [];
      message = "At least one run must be configured.";
    }
    {
      assertion = lib.all (run: run.urls != []) cfg.runs;
      message = "All runs must have at least one url configured.";
    }
  ];

    systemd.services.sitespeed-io = {
      description = "Check website status";
      startAt = cfg.period;
      serviceConfig = {
        WorkingDirectory = cfg.dataDir;
        User = cfg.user;
      };
      preStart = "chmod u+w -R ${cfg.dataDir}"; # Make sure things are writable
      script = (lib.concatMapStrings (run: ''
        ${lib.getExe cfg.package} \
          --config ${format.generate "sitespeed.json" run.settings} \
          ${lib.escapeShellArgs run.extraArgs} \
          ${builtins.toFile "urls.txt" (lib.concatLines run.urls)} &
      '') cfg.runs) +
      ''
        wait
      '';
    };

    users = {
      extraUsers.${cfg.user} = {
        isSystemUser = true;
        group = cfg.user;
        home = cfg.dataDir;
        createHome = true;
        homeMode = "755";
      };
      extraGroups.${cfg.user} = { };
    };
  };
}
