{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.sozu;

  settingsFormat = pkgs.formats.toml {};
  sozuToml = settingsFormat.generate "sozu.toml" cfg.settings;

  usingDefaultDataDir = cfg.dataDir == "/var/lib/sozu";
  usingDefaultUserAndGroup = cfg.user == "sozu" && cfg.group == "sozu";
in
{

  options.services.sozu = {
    enable = mkEnableOption "Sozu";

    package = lib.mkPackageOption pkgs "Sozu" {
      default = [ "sozu" ];
    };

    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = settingsFormat.type;

        options."command_socket" = lib.mkOption {
          type = lib.types.str;
          default = "/run/sozu/sozu.sock";
          description = ''
            Command socket for Sozu.
          '';
        };

        options."pid_file_path" = lib.mkOption {
          type = lib.types.str;
          default = "/run/sozu/sozu.pid";
          description = ''
            PID file path for Sozu.
          '';
        };

        options."saved_state" = lib.mkOption {
          type = lib.types.str;
          default = "/var/lib/sozu/state.json";
          description = ''
            Path from which Sozu tries to load its state at startup.
          '';
        };
      };

      default = {};

      description = ''
        Sozu configuration.
      '';
    };

    dataDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/sozu";
      apply = converge (removeSuffix "/");
      description = ''
        Data directory for Sozu. If you change this, you need to
        manually create the directory. You also need to create the
        `sozu` user and group, or change
        [](#opt-services.sozu.user) and
        [](#opt-services.sozu.group) to existing ones with
        access to the directory.
      '';
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "sozu";
      description = ''
        The user Sozu runs as. Should be left at default unless
        you have very specific needs.
      '';
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "sozu";
      description = ''
        The group Sozu runs as. Should be left at default unless
        you have very specific needs.
      '';
    };

    extraFlags = lib.mkOption {
      description = "Extra command line options to pass to Sozu.";
      default = [ ];
      type = lib.types.listOf lib.types.str;
    };

    restartIfChanged = lib.mkOption {
      type = lib.types.bool;
      description = ''
        Automatically restart the service on config change.
        This can be set to false to defer restarts on a server or cluster.
        Please consider the security implications of inadvertently running an older version,
        and the possibility of unexpected behavior caused by inconsistent versions across a cluster when disabling this option.
      '';
      default = true;
    };
  };

  config = mkIf cfg.enable {
    systemd.services.sozu = {
      description = "Sozu";
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      inherit (cfg) restartIfChanged;
      environment = {
      };
      serviceConfig = {
        ExecStart = ''
          ${cfg.package}/bin/sozu start --config ${sozuToml} \
          ${escapeShellArgs cfg.extraFlags}
        '';
        User = cfg.user;
        Group = cfg.group;
        Restart = "on-failure";
        DynamicUser = usingDefaultUserAndGroup && usingDefaultDataDir;
        RuntimeDirectory = "sozu";
        PIDFile = cfg.settings."pid_file_path";
        AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
        CapabilityBoundingSet = [ "CAP_NET_BIND_SERVICE" ];
        ProtectSystem = "strict";
        ReadWritePaths = [
          "/var/lib/sozu"
        ];
        RestrictAddressFamilies = [
          "AF_UNIX"
          "AF_INET"
          "AF_INET6"
        ];
      } // (optionalAttrs (usingDefaultDataDir) {
        StateDirectory = "sozu";
        StateDirectoryMode = "0700";
      });
    };

    environment.systemPackages = [ cfg.package ];
  };
}
