{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.luker;
  defaultUser = "luker";
  defaultGroup = "luker";
in
{
  meta.maintainers = [ lib.maintainers.MCSeekeri ];

  options = {
    services.luker = {
      enable = lib.mkEnableOption "luker";

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

      package = lib.mkPackageOption pkgs "luker" { };

      configFile = lib.mkOption {
        type = lib.types.path;
        default = "${cfg.package}/lib/node_modules/luker/config.yaml";
        defaultText = lib.literalExpression "\${cfg.package}/lib/node_modules/luker/config.yaml";
        description = ''
          Path to the Luker configuration file.
        '';
      };

      plugins = lib.mkOption {
        type = lib.types.attrsOf lib.types.path;
        default = { };
        example = lib.literalExpression ''
          {
            my-plugin = pkgs.fetchFromGitHub {
              owner = "example";
              repo = "luker-plugin";
              rev = "v1.0.0";
              hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
            };
          }
        '';
        description = "Server plugins, keyed by directory name.";
      };

      extensions = lib.mkOption {
        type = lib.types.attrsOf lib.types.path;
        default = { };
        example = lib.literalExpression ''
          {
            my-extension = pkgs.fetchFromGitHub {
              owner = "example";
              repo = "luker-extension";
              rev = "v1.0.0";
              hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
            };
          }
        '';
        description = "Third-party extensions, keyed by directory name.";
      };

      port = lib.mkOption {
        type = lib.types.nullOr lib.types.port;
        default = null;
        example = 8000;
        description = ''
          Port on which Luker will listen.
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
    assertions = [
      {
        assertion = !config.services.sillytavern.enable;
        message = "services.luker cannot be used together with services.sillytavern.";
      }
    ];

    systemd.services.luker = {
      description = "Luker";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      path = [ pkgs.gitMinimal ]; # required by luker's extension manager
      environment = {
        XDG_DATA_HOME = "%S";
        LUKER_DISABLEUPDATECHECK = "true";
      };
      serviceConfig = {
        Type = "simple";
        ExecStart =
          let
            f = x: name: lib.optional (x != null) "--${name}=${toString x}";
          in
          lib.concatStringsSep " " (
            [
              "${lib.getExe cfg.package}"
            ]
            ++ f cfg.port "port"
            ++ f cfg.listen "listen"
            ++ f cfg.listenAddressIPv4 "listenAddressIPv4"
            ++ f cfg.listenAddressIPv6 "listenAddressIPv6"
            ++ f cfg.whitelist "whitelist"
            ++ [
              "--serverPluginsPath=%S/SillyTavern/plugins"
              "--globalExtensionsPath=%S/SillyTavern/extensions"
            ]
          );
        User = cfg.user;
        Group = cfg.group;
        Restart = "always";
        StateDirectory = "SillyTavern";
        StateDirectoryMode = "0700";
        BindReadOnlyPaths = [
          "/var/lib/SillyTavern/scaffold:${cfg.package}/lib/node_modules/luker/default/scaffold"
        ];
        CapabilityBoundingSet = [ "" ];
        LockPersonality = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateMounts = true;
        PrivateTmp = true;
        PrivateUsers = true;
        ProcSubset = "pid";
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProtectSystem = "strict";
        RemoveIPC = true;
        RestrictAddressFamilies = [
          "AF_UNIX"
          "AF_INET"
          "AF_INET6"
          "AF_NETLINK"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        UMask = "0077";
      };
    };

    users.users.${cfg.user} = lib.mkIf (cfg.user == defaultUser) {
      description = "luker service user";
      isSystemUser = true;
      inherit (cfg) group;
    };

    users.groups.${cfg.group} = lib.mkIf (cfg.group == defaultGroup) { };

    systemd.tmpfiles.settings.luker = {
      "/var/lib/SillyTavern/data".d = {
        mode = "0700";
        inherit (cfg) user group;
      };
      "/var/lib/SillyTavern/extensions".d = {
        mode = "0700";
        inherit (cfg) user group;
      };
      "/var/lib/SillyTavern/plugins".d = {
        mode = "0700";
        inherit (cfg) user group;
      };
      "/var/lib/SillyTavern/scaffold".d = {
        mode = "0700";
        inherit (cfg) user group;
      };
      "/var/lib/SillyTavern/config.yaml"."L+" = {
        mode = "0600";
        argument = cfg.configFile;
        inherit (cfg) user group;
      };
    }
    // lib.mapAttrs' (
      name: src:
      lib.nameValuePair "/var/lib/SillyTavern/plugins/${name}" {
        "L+" = {
          argument = src;
          inherit (cfg) user group;
        };
      }
    ) cfg.plugins
    // lib.mapAttrs' (
      name: src:
      lib.nameValuePair "/var/lib/SillyTavern/extensions/${name}" {
        "L+" = {
          argument = src;
          inherit (cfg) user group;
        };
      }
    ) cfg.extensions;
  };
}
