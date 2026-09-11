{
  lib,
  config,
  pkgs,
  ...
}:

let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    mkPackageOption
    getExe'
    ;
  cfg = config.services.cardwired;
  tomlFormat = pkgs.formats.toml { };
in
{
  options.services.cardwired = {
    enable = mkEnableOption "Cardwire eBPF-based GPU manager daemon";

    package = mkPackageOption pkgs "cardwire" { };

    settings = mkOption {
      type = types.submodule {
        options = {
          auto_apply_gpu_state = mkOption {
            type = types.bool;
            default = true;
            description = ''
              Automatically restore GPU states on manual mode.
            '';
          };
          experimental_nvidia_block = mkOption {
            type = types.bool;
            default = false;
            description = ''
              Enable blocking specifics Nvidia files. This setting is experimental
              because these files can be shared across multiple Nvidia GPUs.
            '';
          };
          battery_auto_switch = mkOption {
            type = types.bool;
            default = false;
            description = ''
              Automatically switch mode on AC power.
            '';
          };
          battery_auto_switch_mode = mkOption {
            type = types.enum [
              "integrated"
              "hybrid"
              "manual"
              "smart"
            ];
            default = "hybrid";
            description = ''
              The mode cardwire switches on AC power.
            '';
          };
          external_display_auto_switch = mkOption {
            type = types.bool;
            default = false;
            description = ''
              Automatically make GPUs available for displays connected to dGPU-only ports.
            '';
          };
        };
      };
      default = { };
      description = ''
        Configuration for {file}`/etc/cardwire.toml`
        See <https://opengamingcollective.github.io/cardwire/getting-started/usage>
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.etc."cardwire/cardwire.toml".source = tomlFormat.generate "cardwire.toml" cfg.settings;

    services.dbus.enable = true;
    services.dbus.packages = [ cfg.package ];
    environment.systemPackages = [ cfg.package ];

    systemd.services.cardwired = {
      description = "Cardwire Daemon";

      restartTriggers = [ config.environment.etc."cardwire/cardwire.toml".source ];

      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "dbus";
        BusName = "org.opengamingcollective.cardwire";
        ExecStart = getExe' cfg.package "cardwired";
        Restart = "on-failure";
        RestartSec = "5s";
        User = "root";
        PrivateNetwork = true;
        PrivateTmp = true;
        ProtectHostname = true;
        NoNewPrivileges = true;
        ProtectClock = true;
        ProtectSystem = "strict";
        StateDirectory = "cardwire";
        StateDirectoryMode = "0700";
        ConfigurationDirectory = "cardwire";
        ConfigurationDirectoryMode = "0700";
        ProtectHome = "read-only";
        ProtectKernelLogs = true;
        ProtectControlGroups = true;
        ProtectKernelModules = true;
        RestrictAddressFamilies = [
          "AF_UNIX"
          "AF_NETLINK"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        LockPersonality = true;
        UMask = "0077";
        IPAddressDeny = "any";
        CapabilityBoundingSet = [
          "CAP_SYS_ADMIN"
          "CAP_BPF"
          "CAP_SYS_PTRACE"
          "CAP_DAC_OVERRIDE"
        ];
      };
    };
  };
}
