{ config, lib, pkgs, ... }:

with lib;

let
  eachLighthouse = config.services.lighthouse;

  lighthouseOpts = { config, lib, name, ...}: {

    options = {

      beacon = mkOption {
        description = "Beacon node";
        type = types.submodule {
          options = {
            enable = lib.mkEnableOption  "Lightouse Beacon node";

            address = mkOption {
              type = types.str;
              default = "0.0.0.0";
              description = ''
                Listen address of Beacon node.
              '';
            };

            port = mkOption {
              type = types.port;
              default = 9000;
              description = ''
                Port number the Beacon node will be listening on.
              '';
            };

            http = {
              port = mkOption {
                type = types.port;
                default = 5052;
                description = ''
                  Port number of Beacon node RPC service.
                '';
              };

              address = mkOption {
                type = types.str;
                default = "127.0.0.1";
                description = ''
                  Listen address of Beacon node RPC service.
                '';
              };
            };

            metrics = {
              enable = lib.mkEnableOption "Beacon node prometheus metrics";
              address = mkOption {
                type = types.str;
                default = "127.0.0.1";
                description = ''
                  Listen address of Beacon node metrics service.
                '';
              };

              port = mkOption {
                type = types.port;
                default = 5054;
                description = ''
                  Port number of Beacon node metrics service.
                '';
              };
            };

            eth1Endpoints = mkOption {
              type = types.listOf types.str;
              default = ["http://localhost:8545"];
              description = ''
                List of ETH1 nodes to connect to.
              '';
            };

            extraArgs = mkOption {
              type = types.str;
              description = ''
                Additional arguments passed to the lighthouse beacon command.
              '';
              default = "";
              example = "";
            };
          };
        };
      };

      validator = mkOption {
        description = "Validator node";
        type = types.submodule {
          options = {
            enable = mkOption {
              type = types.bool;
              default = false;
              description = "Enable Lightouse Validator node.";
            };

            beaconNodes = mkOption {
              type = types.listOf types.str;
              default = ["http://localhost:5052"];
              description = ''
                Beacon nodes to connect to.
              '';
            };

            metrics = {
              enable = lib.mkEnableOption "Validator node prometheus metrics";
              address = mkOption {
                type = types.str;
                default = "127.0.0.1";
                description = ''
                  Listen address of Validator node metrics service.
                '';
              };

              port = mkOption {
                type = types.port;
                default = 5056;
                description = ''
                  Port number of Validator node metrics service.
                '';
              };
            };

            extraArgs = mkOption {
              type = types.str;
              description = ''
                Additional arguments passed to the lighthouse validator command.
              '';
              default = "";
              example = "";
            };
          };
        };
      };

      network = mkOption {
        type = types.enum [ "prater" "pyrmont" "mainnet" ];
        default = "mainnet";
        description = ''
          The network to connect to. Mainnet is the default ethereum network.
        '';
      };

      extraArgs = mkOption {
        type = types.str;
        description = ''
          Additional arguments passed to every lighthouse command.
        '';
        default = "";
        example = "";
      };

      package = mkOption {
        default = pkgs.lighthouse-ethereum;
        type = types.package;
        description = ''
          Package to use as Lighthouse node.
        '';
      };
    };
  };

  lighthouse-wrapper = (lighthouseName: cfg:
    pkgs.writeScriptBin "lh-${lighthouseName}" ''
      #! ${pkgs.runtimeShell}
      cd ${cfg.package}
      sudo=exec
      if [[ "$USER" != lighthouse-${lighthouseName}-validator ]]; then
        sudo='exec /run/wrappers/bin/sudo -u lighthouse-${lighthouseName}-validator'
      fi
      $sudo \
        ${cfg.package}/bin/lighthouse --network ${cfg.network} --datadir /var/lib/lighthouse-validator/${lighthouseName}/${cfg.network} $*
    ''
  );


in

{

  ###### interface

  options = {
    services.lighthouse = mkOption {
      type = types.attrsOf (types.submodule lighthouseOpts);
      default = {};
      description = "Specification of one or more lighthouse instances.";
    };
  };

  ###### implementation

  config = mkIf (eachLighthouse != {}) {

    # Create a real user for the validator so we can interact with it
    users.users = mapAttrs' (lighthouseName: cfg: (
      nameValuePair "lighthouse-${lighthouseName}-validator" {
      group = "lighthouse";
      createHome = false;
      description = "Lighthouse Validator User (${lighthouseName})";
      home = "/var/lib/lighthouse-validator/${lighthouseName}";
      isSystemUser = true;
      packages = [ cfg.package ];
    })) eachLighthouse;

    users.groups.lighthouse = {};

    # Create a wrapper script for each instance that has the proper data directory set
    environment.systemPackages = flatten (mapAttrsToList lighthouse-wrapper eachLighthouse);

    systemd.tmpfiles.rules = [
       "d '/var/lib/lighthouse-validator' 0770 root lighthouse - -"
    ] ++ flatten (mapAttrsToList (lighthouseName: cfg: [
       "d '/var/lib/lighthouse-validator/${lighthouseName}' 0700 lighthouse-${lighthouseName}-validator lighthouse - -"
    ]) eachLighthouse);

    systemd.services = mapAttrs' (lighthouseName: cfg: (
      nameValuePair "lighthouse-${lighthouseName}-beacon" (mkIf cfg.beacon.enable {
        description = "Lighthouse Beacon node (${lighthouseName})";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];

        serviceConfig = {
          DynamicUser = true;
          Restart = "always";
          StateDirectory = "lighthouse-beacon/${lighthouseName}/${cfg.network}";

          # Hardening measures
          PrivateTmp = "true";
          ProtectSystem = "full";
          NoNewPrivileges = "true";
          PrivateDevices = "true";
          MemoryDenyWriteExecute = "true";
        };

        script = ''
          ${cfg.package}/bin/lighthouse beacon \
            --disable-upnp \
            --http --http-address ${cfg.beacon.http.address} --http-port ${toString cfg.beacon.http.port} \
            --network ${cfg.network} \
            --eth1-endpoints ${lib.concatStringsSep "," cfg.beacon.eth1Endpoints} \
            --port ${toString cfg.beacon.port} --listen-address ${cfg.beacon.address} \
            ${optionalString cfg.beacon.metrics.enable ''--metrics --metrics-address ${cfg.beacon.metrics.address} --metrics-port ${toString cfg.beacon.metrics.port}''} \
            ${cfg.extraArgs} ${cfg.beacon.extraArgs} \
            --datadir /var/lib/lighthouse-beacon/${lighthouseName}/${cfg.network}
        '';
      }))) eachLighthouse // mapAttrs' (lighthouseName: cfg: (
      nameValuePair "lighthouse-${lighthouseName}-validator" (mkIf cfg.validator.enable {
        description = "Lighthouse Validator node (${lighthouseName})";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];

        serviceConfig = {
          User = "lighthouse-${lighthouseName}-validator";
          Group = "lighthouse";
          Restart = "always";
          StateDirectory = "lighthouse-validator/${lighthouseName}/${cfg.network}";

          # Hardening measures
          PrivateTmp = "true";
          ProtectSystem = "full";
          NoNewPrivileges = "true";
          PrivateDevices = "true";
          MemoryDenyWriteExecute = "true";
        };

        script = ''
          ${cfg.package}/bin/lighthouse validator \
            --network ${cfg.network} \
            --beacon-nodes ${lib.concatStringsSep "," cfg.validator.beaconNodes} \
            ${optionalString cfg.validator.metrics.enable ''--metrics --metrics-address ${cfg.validator.metrics.address} --metrics-port ${toString cfg.validator.metrics.port}''} \
            ${cfg.extraArgs} ${cfg.validator.extraArgs} \
            --datadir /var/lib/lighthouse-validator/${lighthouseName}/${cfg.network}
        '';
      }))) eachLighthouse;

  };

}
