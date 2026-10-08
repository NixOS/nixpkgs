{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.lubelogger;
in
{
  meta.maintainers = with lib.maintainers; [
    bct
    lyndeno
  ];

  options = {
    services.lubelogger = {
      enable = lib.mkEnableOption "LubeLogger, a self-hosted, open-source, web-based vehicle maintenance and fuel milage tracker";

      package = lib.mkPackageOption pkgs "lubelogger" { };

      dataDir = lib.mkOption {
        description = "Path to LubeLogger config and metadata inside of `/var/lib/`.";
        default = "lubelogger";
        type = lib.types.str;
      };

      port = lib.mkOption {
        description = "The TCP port LubeLogger will listen on.";
        default = 5000;
        type = lib.types.port;
      };

      user = lib.mkOption {
        description = "User account under which LubeLogger runs.";
        default = "lubelogger";
        type = lib.types.str;
      };

      group = lib.mkOption {
        description = "Group under which LubeLogger runs.";
        default = "lubelogger";
        type = lib.types.str;
      };

      openFirewall = lib.mkOption {
        description = "Open ports in the firewall for the LubeLogger web interface.";
        default = false;
        type = lib.types.bool;
      };

      settings = lib.mkOption {
        type = with lib.types; attrsOf str;
        default = { };
        example = {
          LUBELOGGER_ALLOWED_FILE_EXTENSIONS = "";
          LUBELOGGER_LOGO_URL = "";
        };
        description = ''
          Additional configuration for LubeLogger, see <https://docs.lubelogger.com/Environment%20Variables> for supported values.
        '';
      };

      environmentFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        example = "/run/secrets/lubelogger";
        description = ''
          Path to a file containing extra LubeLogger config options in the systemd `EnvironmentFile` format.
          Refer to the [documentation] for supported options.

          [documentation]: https://docs.lubelogger.com/Advanced/Environment%20Variables

          This can be used to pass secrets to LubeLogger without putting them in the Nix store.

          For example, to set an SMTP password, point `environmentFile` at a file containing:
          ```
          MailConfig__Password=<pass>
          ```
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.lubelogger = {
      description = "LubeLogger";

      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      environment = {
        Kestrel__Endpoints__Http__Url = "http://localhost:${toString cfg.port}";
      }
      // cfg.settings;

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        StateDirectory = cfg.dataDir;
        WorkingDirectory = "/var/lib/${cfg.dataDir}";
        ExecStart = lib.getExe cfg.package;
        EnvironmentFile = lib.mkIf (cfg.environmentFile != null) cfg.environmentFile;
        Restart = "on-failure";

        CapabilityBoundingSet = [ "" ];
        DeviceAllow = [ "" ];
        PrivateDevices = true;
        PrivateTmp = true;
        ProtectHome = true;
        RestrictAddressFamilies = [
          "AF_UNIX"
          "AF_INET"
          "AF_INET6"
        ];
        RestrictNamespaces = true;
      };
    };

    users.users = lib.mkIf (cfg.user == "lubelogger") {
      lubelogger = {
        isSystemUser = true;
        group = cfg.group;
        home = "/var/lib/${cfg.dataDir}";
      };
    };

    users.groups = lib.mkIf (cfg.group == "lubelogger") { lubelogger = { }; };

    networking.firewall = lib.mkIf cfg.openFirewall { allowedTCPPorts = [ cfg.port ]; };
  };
}
