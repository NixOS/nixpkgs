{ lib, config, pkgs, ... }:
with lib;
let
  cfg = config.services.wgautomesh;
  settingsFormat = pkgs.formats.toml { };
  configFile =
    # Have to remove nulls manually as TOML generator will not just skip key
    # if value is null
    settingsFormat.generate "wgautomesh-config.toml"
      (filterAttrs (k: v: v != null)
        (mapAttrs
          (k: v:
            if k == "peers"
            then map (e: filterAttrs (k: v: v != null) e) v
            else v)
          cfg.settings));
  runtimeConfigFile =
    if cfg.enableGossipEncryption
    then "/run/wgautomesh/wgautomesh.toml"
    else configFile;
in
{
  options.services.wgautomesh = {
    enable = mkEnableOption "the wgautomesh daemon";
    logLevel = mkOption {
      type = types.enum [ "trace" "debug" "info" "warn" "error" ];
      default = "info";
      description = "wgautomesh log level.";
    };
    enableGossipEncryption = mkOption {
      type = types.bool;
      default = true;
      description = "Enable encryption of gossip traffic.";
    };
    gossipSecretFile = mkOption {
      type = types.path;
      description = ''
        File containing the gossip secret, a shared secret key to use for gossip
        encryption.  Required if `enableGossipEncryption` is set.  This file
        may contain any arbitrary-length utf8 string.  To generate a new gossip
        secret, use a command such as `openssl rand -base64 32`.
      '';
    };
    enablePersistence = mkOption {
      type = types.bool;
      default = true;
      description = "Enable persistence of Wireguard peer info between restarts.";
    };
    openFirewall = mkOption {
      type = types.bool;
      default = true;
      description = "Automatically open gossip port in firewall (recommended).";
    };
    settings = mkOption {
      type = types.submodule {
        freeformType = settingsFormat.type;
        options = {

          interface = mkOption {
            type = types.str;
            description = ''
              Wireguard interface to manage (it is NOT created by wgautomesh, you
              should use another NixOS option to create it such as
              `networking.wireguard.interfaces.wg0 = {...};`).
            '';
            example = "wg0";
          };
          gossip_port = mkOption {
            type = types.port;
            description = ''
              wgautomesh gossip port, this MUST be the same number on all nodes in
              the wgautomesh network.
            '';
            default = 1666;
          };
          lan_discovery = mkOption {
            type = types.bool;
            default = true;
            description = "Enable discovery of peers on the same LAN using UDP broadcast.";
          };
          upnp_forward_external_port = mkOption {
            type = types.nullOr types.port;
            default = null;
            description = ''
              Public port number to try to redirect to this machine's Wireguard
              daemon using UPnP IGD.
            '';
          };
          peers = mkOption {
            type = types.listOf (types.submodule {
              options = {
                pubkey = mkOption {
                  type = types.str;
                  description = "Wireguard public key of this peer.";
                };
                address = mkOption {
                  type = types.str;
                  description = ''
                    Wireguard address of this peer (a single IP address, multiple
                    addresses or address ranges are not supported).
                  '';
                  example = "10.0.0.42";
                };
                endpoint = mkOption {
                  type = types.nullOr types.str;
                  description = ''
                    Bootstrap endpoint for connecting to this Wireguard peer if no
                    other address is known or none are working.
                  '';
                  default = null;
                  example = "wgnode.mydomain.example:51820";
                };
              };
            });
            default = [ ];
            description = "wgautomesh peer list.";
          };
        };

      };
      default = { };
      description = "Configuration for wgautomesh.";
    };
  };

  config = mkIf cfg.enable {
    services.wgautomesh.settings = {
      gossip_secret_file = mkIf cfg.enableGossipEncryption "$CREDENTIALS_DIRECTORY/gossip_secret";
      persist_file = mkIf cfg.enablePersistence "/var/lib/wgautomesh/state";
    };

    systemd.services.wgautomesh = {
      path = [ pkgs.wireguard-tools ];
      environment = { RUST_LOG = "wgautomesh=${cfg.logLevel}"; };
      description = "wgautomesh";
      serviceConfig = {
        Type = "simple";

        ExecStart = "${getExe pkgs.wgautomesh} ${runtimeConfigFile}";
        Restart = "always";
        RestartSec = "30";
        LoadCredential = mkIf cfg.enableGossipEncryption [ "gossip_secret:${cfg.gossipSecretFile}" ];

        ExecStartPre = mkIf cfg.enableGossipEncryption [
          ''${pkgs.envsubst}/bin/envsubst \
              -i ${configFile} \
              -o ${runtimeConfigFile}''
        ];

        DynamicUser = true;
        StateDirectory = "wgautomesh";
        StateDirectoryMode = "0700";
        RuntimeDirectory = "wgautomesh";
        AmbientCapabilities = "CAP_NET_ADMIN";
        CapabilityBoundingSet = "CAP_NET_ADMIN";
      };
      wantedBy = [ "multi-user.target" ];
    };
    networking.firewall.allowedUDPPorts =
      mkIf cfg.openFirewall [ cfg.settings.gossip_port ];
  };
}

