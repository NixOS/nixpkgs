{ config, lib, pkgs, utils, ... }:
with lib;
let
  cfg = config.services.yggdrasil.jumper;
  ygg-cfg = config.services.yggdrasil;

  format = pkgs.formats.toml { };
  configFile = format.generate "yggdrasil-jumper.toml" cfg.settings;
in
{
  options = with types; {
    services.yggdrasil.jumper = {
      enable = mkEnableOption "the yggdrasil-jumper nat-traversal service";

      package = mkPackageOption pkgs "yggdrasil-jumper" { };

      openFirewall = mkOption {
        type = bool;
        default = true;
        example = false;
        description = "Open port specified in settings.listen_port.";
      };

      settings = mkOption {
        type = format.type;
        default = {
          yggdrasil_listen = mkIf (builtins.hasAttr "Listen" ygg-cfg.settings ) ygg-cfg.settings.Listen;
          allow_ipv4 = true;
          allow_ipv6 = true;
          listen_port = 4701;
        };
        defaultText = literalExpression ''
          {
            yggdrasil_listen = mkIf (builtins.hasAttr "Listen" ygg-cfg.settings ) ygg-cfg.settings.Listen;
            allow_ipv4 = true;
            allow_ipv6 = true;
            listen_port = 4701;
          }
        '';
        example = {
          yggdrasil_admin_listen = [ "tcp://localhost:9001" ];
          stun_servers = [
            "stunserver.stunprotocol.org:3478"
          ];
          stun_randomize = false;
        };
        description = ''
          Configuration for yggdrasil-jumper, as a Nix attribute set.

          Warning: it isn't recommended to change listen_port, because
          yggdrasil-jumper will connect only to nodes with the same port.

          You can use the command `nix-shell -p yggdrasil-jumper --run "yggdrasil-jumper --print-default"`
          to generate default configuration values with documentation.
        '';
      };

      extraArgs = mkOption {
        type = listOf str;
        default = [ ];
        example = [ "--loglevel" "debug" ];
        description = "Extra command line arguments.";
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.yggdrasil-jumper = {
      description = "Yggdrasil-jumper NAT Traversal Service";
      after = [ "yggdrasil.service" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        ExecStart = utils.escapeSystemdExecArgs ([
          (getExe cfg.package)
          "--config"
          configFile
        ] ++ cfg.extraArgs);
        Restart = "always";

        DynamicUser = true;

        User = "yggdrasil";
        ReadOnlyPaths = ["/run/yggdrasil/yggdrasil.sock"];

        AmbientCapabilities = "CAP_NET_BIND_SERVICE";
        CapabilityBoundingSet = "CAP_NET_BIND_SERVICE";
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateIPC = true;
        PrivateTmp = true;
        PrivateUsers = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = "tmpfs";
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        RestrictAddressFamilies = "AF_UNIX AF_INET AF_INET6";
        RestrictNamespaces = true;
        RestrictRealtime = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [];
      };
    };

    networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall [ cfg.settings.listen_port ];
  };
  meta = {
    maintainers = with lib.maintainers; [ averyanalex ];
  };
}
