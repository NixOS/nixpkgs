{ config, lib, pkgs, ... }:

let
  cfg = config.services.lokinet;
  dataDir = "/var/lib/lokinet";
  settingsFormat = pkgs.formats.ini { listsAsDuplicateKeys = true; };
  configFile = settingsFormat.generate "lokinet.ini" (lib.filterAttrsRecursive (n: v: v != null) cfg.settings);
in with lib; {
  options.services.lokinet = {
    enable = mkEnableOption "Lokinet daemon";

    package = mkOption {
      type = types.package;
      default = pkgs.lokinet;
      defaultText = literalExpression "pkgs.lokinet";
      description = lib.mdDoc "Lokinet package to use.";
    };

    useLocally = mkOption {
      type = types.bool;
      default = false;
      example = true;
      description = lib.mdDoc "Whether to use Lokinet locally.";
    };

    settings = mkOption {
      type = with types;
        submodule {
          freeformType = settingsFormat.type;

          options = {
            dns = {
              bind = mkOption {
                type = str;
                default = "127.3.2.1";
                description = lib.mdDoc "Address to bind to for handling DNS requests.";
              };

              upstream = mkOption {
                type = listOf str;
                default = [ "9.9.9.10" ];
                example = [ "1.1.1.1" "8.8.8.8" ];
                description = lib.mdDoc ''
                  Upstream resolver(s) to use as fallback for non-loki addresses.
                  Multiple values accepted.
                '';
              };
            };

            network = {
              exit = mkOption {
                type = bool;
                default = false;
                description = lib.mdDoc ''
                  Whether to act as an exit node. Beware that this
                  increases demand on the server and may pose liability concerns.
                  Enable at your own risk.
                '';
              };

              exit-node = mkOption {
                type = nullOr (listOf str);
                default = null;
                example = ''
                  exit-node = [ "example.loki" ];              # maps all exit traffic to example.loki
                  exit-node = [ "example.loki:100.0.0.0/24" ]; # maps 100.0.0.0/24 to example.loki
                '';
                description = lib.mdDoc ''
                  Specify a `.loki` address and an optional ip range to use as an exit broker.
                  See <http://probably.loki/wiki/index.php?title=Exit_Nodes> for
                  a list of exit nodes.
                '';
              };

              keyfile = mkOption {
                type = nullOr str;
                default = null;
                example = "snappkey.private";
                description = lib.mdDoc ''
                  The private key to persist address with. If not specified the address will be ephemeral.
                  This keyfile is generated automatically if the specified file doesn't exist.
                '';
              };
            };
          };
        };
      default = { };
      example = literalExpression ''
        {
          dns = {
            bind = "127.3.2.1";
            upstream = [ "1.1.1.1" "8.8.8.8" ];
          };

          network.exit-node = [ "example.loki" "example2.loki" ];
        }
      '';
      description = lib.mdDoc ''
        Configuration for Lokinet.
        Currently, the best way to view the available settings is by
        generating a config file using `lokinet -g`.
      '';
    };
  };

  config = mkIf cfg.enable {
    networking.resolvconf.extraConfig = mkIf cfg.useLocally ''
      name_servers="${cfg.settings.dns.bind}"
    '';

    systemd.services.lokinet = {
      description = "Lokinet";
      after = [ "network-online.target" "network.target" ];
      wants = [ "network-online.target" "network.target" ];
      wantedBy = [ "multi-user.target" ];

      preStart = ''
        ln -sf ${cfg.package}/share/bootstrap.signed ${dataDir}
        ${pkgs.coreutils}/bin/install -m 600 ${configFile} ${dataDir}/lokinet.ini

        ${optionalString (cfg.settings.network.keyfile != null) ''
          ${pkgs.crudini}/bin/crudini --set ${dataDir}/lokinet.ini network keyfile "${dataDir}/${cfg.settings.network.keyfile}"
        ''}
      '';

      serviceConfig = {
        DynamicUser = true;
        StateDirectory = "lokinet";
        AmbientCapabilities = [ "CAP_NET_ADMIN" "CAP_NET_BIND_SERVICE" ];
        ExecStart = "${cfg.package}/bin/lokinet ${dataDir}/lokinet.ini";
        Restart = "always";
        RestartSec = "5s";

        # hardening
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateTmp = true;
        PrivateMounts = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectSystem = "strict";
        ReadWritePaths = "/dev/net/tun";
        RestrictAddressFamilies = [ "AF_UNIX" "AF_INET" "AF_INET6" "AF_NETLINK" ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
      };
    };

    environment.systemPackages = [ cfg.package ];
  };
}
