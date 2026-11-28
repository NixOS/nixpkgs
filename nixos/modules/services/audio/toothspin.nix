{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.toothspin;
in
{
  options.services.toothspin = {
    enable = lib.mkEnableOption "ToothSpin Bluetooth audio input";

    package = lib.mkPackageOption pkgs "toothspin" { };

    environmentFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = ''
        Path to an environment file, as defined in {manpage}`systemd.exec(5)`,
        Use this for secrets such as `MA_TOKEN`.
        See <https://github.com/eknoes/toothspin/blob/main/README.md#configuration> for a full list of environment variables.
      '';
    };

    bluetoothName = lib.mkOption {
      type = lib.types.str;
      default = "ToothSpin";
      description = "Bluetooth device name to advertise.";
    };

    webPort = lib.mkOption {
      type = lib.types.port;
      default = 8080;
      description = "TCP port for the ToothSpin web interface.";
    };

    musicAssistantUrl = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = ''
        URL of the Music Assistant server. When this is null, mDNS is used to discover Music Assistant.
      '';
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "toothspin";
      description = "User account under which ToothSpin runs.";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "toothspin";
      description = "Primary group for the ToothSpin service user.";
    };
  };

  config = lib.mkIf cfg.enable {
    hardware.bluetooth = {
      enable = true;
      # The hostname plugin would otherwise override General.Class.
      disabledPlugins = [ "hostname" ];
      # https://github.com/eknoes/toothspin/blob/main/deploy/bluetooth/main.conf
      settings = {
        General = {
          Class = "0x000414";
          DiscoverableTimeout = 0;
          PairableTimeout = 0;
          FastConnectable = true;
        };
        Policy = {
          AutoEnable = true;
          ReconnectAttempts = 0;
        };
      };
    };

    services.pipewire = {
      enable = true;
      audio.enable = true;
      systemWide = true;
      wireplumber.configPackages = [
        (pkgs.runCommand "50-toothspin.conf" { } ''
          dir=$out/share/wireplumber/wireplumber.conf.d/
          mkdir -p $dir
          cp ${cfg.package.src}/deploy/pipewire/50-toothspin.conf $dir
        '')
      ];
    };

    systemd.services.toothspin = {
      description = "ToothSpin Bluetooth audio input";
      after = [
        "network.target"
        "pipewire.target"
      ];
      wantedBy = [ "multi-user.target" ];
      path = [ pkgs.pipewire ];

      environment = {
        BT_NAME = cfg.bluetoothName;
        DATA_DIR = "/var/lib/toothspin";
        PIPEWIRE_RUNTIME_DIR = "/run/pipewire";
        PYTHONUNBUFFERED = "1";
        WEB_PORT = toString cfg.webPort;
      }
      // lib.optionalAttrs (cfg.musicAssistantUrl != null) {
        MA_URL = cfg.musicAssistantUrl;
      };

      serviceConfig = {
        ExecStart = lib.getExe cfg.package;
        Restart = "on-failure";
        StateDirectory = "toothspin";
        User = cfg.user;
        Group = cfg.group;
      }
      // lib.optionalAttrs (cfg.environmentFile != null) {
        EnvironmentFile = [ cfg.environmentFile ];
      };
    };

    users = {
      groups.${cfg.group} = { };
      users.${cfg.user} = {
        description = "ToothSpin service user";
        inherit (cfg) group;
        isSystemUser = true;
        extraGroups = [ "pipewire" ];
      };
    };
  };
}
