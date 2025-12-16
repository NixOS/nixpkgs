{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.angrr;
  direnvCfg = config.programs.direnv.angrr;
  toml = pkgs.formats.toml { };
  exampleSettings = {
    temporary-root-policies = {
      direnv = {
        path-regex = "/\\.direnv/";
        period = "14d";
      };
      result = {
        path-regex = "/result[^/]*$";
        period = "3d";
      };
    };
    profile-policies = {
      system = {
        profile-paths = [ "/nix/var/nix/profiles/system" ];
        keep-since = "14d";
        keep-latest-n = 5;
        keep-booted-system = true;
        keep-current-system = true;
      };
      user = {
        enable = false;
        profile-paths = [
          "~/.local/state/nix/profiles/profile"
          "/nix/var/nix/profiles/per-user/root/profile"
        ];
        keep-since = "1d";
        keep-latest-n = 1;
        keep-booted-system = false;
        keep-current-system = false;
      };
    };
  };
  settingsOptions = {
    freeformType = toml.type;
    options = {
      owned-only = lib.mkOption {
        type =
          with lib.types;
          enum [
            "auto"
            "true"
            "false"
          ];
        default = "auto";
        description = ''
          Only monitors owned symbolic link target of GC roots.

          - "auto": behaves like true for normal users, false for root.
          - "true": only monitor GC roots owned by the current user.
          - "false": monitor all GC roots.
        '';
      };
      temporary-root-policies = lib.mkOption {
        type = with lib.types; attrsOf (submodule temporaryRootPolicyOptions);
        default = { };
        description = ''
          Policies for temporary GC roots(e.g. result and direnv).
        '';
      };
      profile-policies = lib.mkOption {
        type = with lib.types; attrsOf (submodule profilePolicyOptions);
        default = { };
        description = ''
          Profile GC root policies.
        '';
      };
      touch = {
        project-globs = lib.mkOption {
          type = with lib.types; listOf str;
          default = [
            "!.git"
          ];
          description = ''
            List of glob patterns to include or exclude files when touching GC roots.

            Only applied when `angrr touch` is invoked with the `--project` flag.
            Patterns use an inverted gitignore-style semantics.
            See <https://docs.rs/ignore/latest/ignore/overrides/struct.OverrideBuilder.html#method.add>.
          '';
        };
      };
    };
  };
  commonPolicyOptions = {
    options = {
      enable = lib.mkEnableOption "this angrr policy" // {
        default = true;
        example = false;
      };
    };
  };
  temporaryRootPolicyOptions = {
    freeformType = toml.type;
    imports = [ commonPolicyOptions ];
    options = {
      path-regex = lib.mkOption {
        type = lib.types.str;
        description = ''
          Regex pattern to match the GC root path.
        '';
      };
      period = lib.mkOption {
        type = with lib.types; nullOr str;
        default = null;
        description = ''
          Retention period for the GC roots matched by this policy.
        '';
      };
      priority = lib.mkOption {
        type = lib.types.int;
        default = 100;
        description = ''
          Priority of this policy.

          Lower number means higher priority, if multiple policies monitor the
          same path, the one with higher priority will be applied.
        '';
      };
      filter = lib.mkOption {
        type = with lib.types; nullOr (submodule filterOptions);
        default = null;
        description = ''
          External filter program to further filter GC roots matched by this policy.
        '';
      };
      ignore-prefixes = lib.mkOption {
        type = with lib.types; nullOr (listOf str);
        default = null;
        description = ''
          List of path prefixes to ignore.

          If null is specified, angrr builtin settings will be used.
        '';
      };
      ignore-prefixes-in-home = lib.mkOption {
        type = with lib.types; nullOr (listOf str);
        default = null;
        description = ''
          Path prefixes to ignore under home directory.

          If null is specified, angrr builtin settings will be used.
        '';
      };
    };
  };
  profilePolicyOptions = {
    freeformType = toml.type;
    imports = [ commonPolicyOptions ];
    options = {
      profile-paths = lib.mkOption {
        type = with lib.types; listOf str;
        description = ''
          Paths to the Nix profile.

          When angrr runs in owned-only mode, and the option begins with `~`,
          it will be expanded to the home directory of the current user.

          When angrr does not run in owned-only mode, and the option begins with `~`,
          it will be expanded to the home of all users discovered respectively.
        '';
      };
      keep-since = lib.mkOption {
        type = with lib.types; nullOr str;
        default = null;
        description = ''
          Retention period for the GC roots in this profile.
        '';
      };
      keep-latest-n = lib.mkOption {
        type = with lib.types; nullOr int;
        default = null;
        description = ''
          Keep the latest N GC roots in this profile.
        '';
      };
      keep-current-system = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to keep the current system generation. Only useful for system profiles.
        '';
      };
      keep-booted-system = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to keep the last booted system generation. Only useful for system profiles.
        '';
      };
    };
  };
  filterOptions = {
    freeformType = toml.type;
    options = {
      program = lib.mkOption {
        type = lib.types.str;
        description = ''
          Path to the external filter program.
        '';
      };
      arguments = lib.mkOption {
        type = with lib.types; listOf str;
        default = [ ];
        description = ''
          Extra command-line arguments pass to the external filter program.
        '';
      };
    };
  };

  # toml.generate does not support null values, we need to filter them out first
  filteredSettings = lib.filterAttrsRecursive (name: value: value != null) cfg.settings;
  originalConfigFile = toml.generate "angrr.toml" filteredSettings;
  validatedConfigFile = pkgs.runCommand "angrr-config.toml" { } ''
    ${lib.getExe cfg.package} validate --config "${originalConfigFile}" > $out
  '';

  configFileMigrationMsg = ''
    This option has been removed since angrr 0.2.0.
    Please use `services.angrr.settings` to configure retention policies through configuration file.

    See <https://github.com/linyinfeng/angrr/tree/main?tab=readme-ov-file#nixos-module-usage> for a configuration example.
  '';
in
{
  meta.maintainers = pkgs.angrr.meta.maintainers;
  imports = [
    (lib.mkRemovedOptionModule [ "services" "angrr" "period" ] configFileMigrationMsg)
    (lib.mkRemovedOptionModule [ "services" "angrr" "removeRoot" ] configFileMigrationMsg)
    (lib.mkRemovedOptionModule [ "services" "angrr" "ownedOnly" ] configFileMigrationMsg)
  ];
  options = {
    services.angrr = {
      enable = lib.mkEnableOption "angrr";
      package = lib.mkPackageOption pkgs "angrr" { };
      logLevel = lib.mkOption {
        type =
          with lib.types;
          enum [
            "off"
            "error"
            "warn"
            "info"
            "debug"
            "trace"
          ];
        default = "info";
        description = ''
          Set the log level of angrr.
        '';
      };
      extraArgs = lib.mkOption {
        type = with lib.types; listOf str;
        default = [ ];
        description = ''
          Extra command-line arguments pass to angrr.
        '';
      };
      settings = lib.mkOption {
        type = lib.types.submodule settingsOptions;
        example = exampleSettings;
        description = ''
          Global configuration for angrr in TOML format.
        '';
      };
      configFile = lib.mkOption {
        type = with lib.types; nullOr path;
        default = validatedConfigFile;
        defaultText = "TOML file generated from {option}`services.angrr.settings`";
        description = ''
          Path to the angrr configuration file in TOML format.

          If not set, the configuration generated from {option}`services.angrr.settings` will be used.
          If specified, {option}`services.angrr.settings` will be ignored.
        '';
      };
      enableNixGcIntegration = lib.mkOption {
        type = lib.types.bool;
        description = ''
          Whether to enable nix-gc.service integration.
        '';
      };
      timer = {
        enable = lib.mkEnableOption "angrr timer";
        dates = lib.mkOption {
          type = lib.types.str;
          default = "03:00";
          description = ''
            How often or when the retention policy is performed.
          '';
        };
      };
    };
    programs.direnv.angrr = {
      enable = lib.mkEnableOption "angrr direnv integration" // {
        default = true;
        example = false;
      };
      autoUse = lib.mkOption {
        type = lib.types.bool;
        default = true;
        example = false;
        description = ''
          Whether to automatically use angrr before loading .envrc.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        assertions = [
          {
            assertion = cfg.enableNixGcIntegration -> config.nix.gc.automatic;
            message = "angrr nix-gc.service integration requires `nix.gc.automatic = true`";
          }
        ];
        services.angrr.enableNixGcIntegration = lib.mkDefault config.nix.gc.automatic;
      }

      {
        environment.etc."angrr/config.toml".source = cfg.configFile;

        systemd.services.angrr = {
          description = "Auto Nix GC Roots Retention";
          script = ''
            ${lib.getExe cfg.package} run \
              --log-level "${cfg.logLevel}" \
              --no-prompt \
              ${lib.escapeShellArgs cfg.extraArgs}
          '';
          environment.ANGRR_LOG_STYLE = "systemd";
          serviceConfig = {
            Type = "oneshot";
          };
        };

        environment.systemPackages = [ cfg.package ];
      }

      (lib.mkIf cfg.timer.enable {
        systemd.timers.angrr = {
          timerConfig = {
            OnCalendar = cfg.timer.dates;
          };
          wantedBy = [ "timers.target" ];
        };
      })

      (lib.mkIf cfg.enableNixGcIntegration {
        systemd.services.angrr = {
          wantedBy = [ "nix-gc.service" ];
          before = [ "nix-gc.service" ];
        };
      })

      (lib.mkIf (config.programs.direnv.enable && direnvCfg.enable) {
        environment.etc."direnv/lib/angrr.sh".source = "${cfg.package}/share/direnv/lib/angrr.sh";
        programs.direnv.direnvrcExtra = lib.mkIf direnvCfg.autoUse ''
          _angrr_auto_use "$@"
        '';
      })
    ]
  );
}
