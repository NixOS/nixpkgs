# NOTE:
# cfg.configFile contains secrets such as proxy servers' credential!
# we dont want plaintext secrets in world-readable `/nix/store`.

{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.services.mihomo;
in
{
  options.services.mihomo = {
    enable = lib.mkEnableOption "Mihomo, A rule-based proxy in Go";

    package = lib.mkPackageOption pkgs "mihomo" { };

    configFile = lib.mkOption {
      type = lib.types.path;
      description = "Configuration file to use.";
    };

    webui = lib.mkOption {
      default = null;
      type = lib.types.nullOr lib.types.path;
      example = lib.literalExpression "pkgs.metacubexd";
      description = ''
        Local web interface to use.

        You can also use the following website:
        - metacubexd:
          - <https://d.metacubex.one>
          - <https://metacubex.github.io/metacubexd>
          - <https://metacubexd.pages.dev>
        - yacd:
          - <https://yacd.haishan.me>
        - clash-dashboard:
          - <https://clash.razord.top>
      '';
    };

    extraOpts = lib.mkOption {
      default = null;
      type = lib.types.nullOr lib.types.str;
      description = "Extra command line options to use.";
    };

    tunMode = lib.mkEnableOption ''
      necessary permission for Mihomo's systemd service for TUN mode to function properly.

      Keep in mind, that you still need to enable TUN mode manually in Mihomo's configuration
    '';
  };

  config = lib.mkIf cfg.enable {
    ### systemd service
    systemd.services."mihomo" = {
      description = "Mihomo daemon, A rule-based proxy in Go.";
      documentation = [ "https://wiki.metacubex.one/" ];
      requires = [ "network-online.target" ];
      after = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = lib.concatStringsSep " " [
          (lib.getExe cfg.package)
          "-d /var/lib/private/mihomo"
          "-f \${CREDENTIALS_DIRECTORY}/config.yaml"
          (lib.optionalString (cfg.webui != null) "-ext-ui ${cfg.webui}")
          (lib.optionalString (cfg.extraOpts != null) cfg.extraOpts)
        ];

        DynamicUser = true;
        StateDirectory = "mihomo";
        LoadCredential = "config.yaml:${cfg.configFile}";

        ### Hardening
        AmbientCapabilities = "";
        CapabilityBoundingSet = "";
        DeviceAllow = "";
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
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
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        RestrictNamespaces = true;
        RestrictAddressFamilies = "AF_INET AF_INET6";
        SystemCallArchitectures = "native";
        SystemCallFilter = "@system-service bpf";
        UMask = "0077";
      }
      // lib.optionalAttrs cfg.tunMode {
        AmbientCapabilities = "CAP_NET_ADMIN";
        CapabilityBoundingSet = "CAP_NET_ADMIN";
        PrivateDevices = false;
        PrivateUsers = false;
        RestrictAddressFamilies = "AF_INET AF_INET6 AF_NETLINK";
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ Guanran928 ];
}
