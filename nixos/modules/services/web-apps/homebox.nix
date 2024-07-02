{ config, lib, pkgs, ... }:

let
  cfg = config.services.homebox;
in {
  meta.maintainers = pkgs.homebox.meta.maintainers;

  options.services.homebox = {

    enable = lib.mkEnableOption "homebox";
    package = lib.mkPackageOption pkgs "homebox" { };

    environment = lib.mkOption {
      default = { };
      type = lib.types.attrsOf lib.types.str;
      example = lib.literalExpression
        ''
          # Both of these defaults are /data/ which we defentivly don't want.
          # The prefered thing would be if upstream just used the `$(pwd)` where the program is started in.
          # Because that's the systemd-default and can also easily be used in a oci container.
          {
            HBOX_STORAGE_DATA = "/var/lib/homebox";
            HBOX_STORAGE_SQLITE_URL = "/var/lib/homebox/homebox.db?_fk=1";
          }
        '';
      description = lib.mdDoc "homebox config environment variables, for other options read the [documentation](https://hay-kot.github.io/homebox/quick-start/#env-variables-configuration)";
    };
    environmentFiles = lib.mkOption {
      type = with lib.types; listOf path;
      default = [ ];
      example = [ "/root/homebox.env" ];
      description = lib.mdDoc ''
        File to load environment variables
        from. This is helpful for specifying secrets.
        Example content of environmentFile:
        ```
        HBOX_MAILER_USERNAME=homebox@example.com
        HBOX_MAILER_PASSWORD=password
        ```
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services = {
      homebox = {
        description = "Homebox Service";
        wantedBy = [ "multi-user.target" ];
        after = [ "network-online.target" ];
        wants = [ "network-online.target" ];
        serviceConfig = {
          DynamicUser = true;
          WorkingDirectory = "%S/homebox";
          StateDirectory = "homebox";
          StateDirectoryMode = "0700";
          UMask = "0007";
          ConfigurationDirectory = "homebox";
          EnvironmentFile = cfg.environmentFiles;
          ExecStart = lib.getExe cfg.package;
          Restart = "on-failure";
          RestartSec = 15;
          CapabilityBoundingSet = "";
          # Security
          NoNewPrivileges = true;
          # Sandboxing
          ProtectSystem = "strict";
          ProtectHome = true;
          PrivateTmp = true;
          PrivateDevices = true;
          PrivateUsers = true;
          ProtectHostname = true;
          ProtectClock = true;
          ProtectKernelTunables = true;
          ProtectKernelModules = true;
          ProtectKernelLogs = true;
          ProtectControlGroups = true;
          RestrictAddressFamilies = [ "AF_UNIX AF_INET AF_INET6" ];
          LockPersonality = true;
          MemoryDenyWriteExecute = true;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
          PrivateMounts = true;
          # System Call Filtering
          SystemCallArchitectures = "native";
          SystemCallFilter = "~@clock @privileged @cpu-emulation @debug @keyring @module @mount @obsolete @raw-io @reboot @setuid @swap";
        };
        inherit (cfg) environment;
      };
    };
  };
}
