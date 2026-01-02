{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.sillytavern;
  defaultUser = "sillytavern";
  defaultGroup = "sillytavern";
in
{
  meta.maintainers = [
    lib.maintainers.wrvsrx
    lib.maintainers.A1ca7raz
  ];

  options = {
    services.sillytavern = {
      enable = lib.mkEnableOption "sillytavern";

      user = lib.mkOption {
        type = lib.types.str;
        default = defaultUser;
        description = ''
          User account under which the web-application run.
        '';
      };
      group = lib.mkOption {
        type = lib.types.str;
        default = defaultGroup;
        description = ''
          Group account under which the web-application run.
        '';
      };

      package = lib.mkPackageOption pkgs "sillytavern" { };

      configFile = lib.mkOption {
        type = lib.types.path;
        default = "${pkgs.sillytavern}/lib/node_modules/sillytavern/config.yaml";
        defaultText = lib.literalExpression "\${pkgs.sillytavern}/lib/node_modules/sillytavern/config.yaml";
        description = ''
          Path to the SillyTavern configuration file.
        '';
      };

      port = lib.mkOption {
        type = lib.types.nullOr lib.types.port;
        default = null;
        example = 8045;
        description = ''
          Port on which SillyTavern will listen.
        '';
      };

      listenAddressIPv4 = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        example = "127.0.0.1";
        description = ''
          Specific IPv4 address to listen to.
        '';
      };

      listenAddressIPv6 = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        example = "::1";
        description = ''
          Specific IPv6 address to listen to.
        '';
      };

      listen = lib.mkOption {
        type = lib.types.nullOr lib.types.bool;
        default = null;
        example = true;
        description = ''
          Whether to listen on all network interfaces.
        '';
      };

      whitelist = lib.mkOption {
        type = lib.types.nullOr lib.types.bool;
        default = null;
        example = true;
        description = ''
          Enables whitelist mode.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.sillytavern = {
      description = "Silly Tavern";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      # required by sillytavern's extension manager
      path = [ pkgs.git ];
      environment.XDG_DATA_HOME = "%S";
      serviceConfig = {
        Type = "simple";
        ExecStart =
          let
            f = x: name: lib.optional (x != null) "--${name}=${builtins.toString x}";
          in
          lib.concatStringsSep " " (
            [
              "${lib.getExe pkgs.sillytavern}"
            ]
            ++ f cfg.port "port"
            ++ f cfg.listen "listen"
            ++ f cfg.listenAddressIPv4 "listenAddressIPv4"
            ++ f cfg.listenAddressIPv6 "listenAddressIPv6"
            ++ f cfg.whitelist "whitelist"
          );
        User = cfg.user;
        Group = cfg.group;
        Restart = "always";
        StateDirectory = "SillyTavern";
        BindPaths = [
          "%S/SillyTavern/extensions:${pkgs.sillytavern}/lib/node_modules/sillytavern/public/scripts/extensions/third-party"
        ];

        # Security hardening
        CapabilityBoundingSet = [ "" ];
        LockPersonality = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateTmp = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProtectSystem = "strict";
      };
    };

    users.users.${cfg.user} = lib.mkIf (cfg.user == defaultUser) {
      description = "sillytavern service user";
      isSystemUser = true;
      inherit (cfg) group;
    };

    users.groups.${cfg.group} = lib.mkIf (cfg.group == defaultGroup) { };

    systemd.tmpfiles.settings.sillytavern = {
      "/var/lib/SillyTavern/data".d = {
        mode = "0700";
        inherit (cfg) user group;
      };
      "/var/lib/SillyTavern/extensions".d = {
        mode = "0700";
        inherit (cfg) user group;
      };
      "/var/lib/SillyTavern/config.yaml"."L+" = {
        mode = "0600";
        argument = cfg.configFile;
        inherit (cfg) user group;
      };
    };
  };
}
