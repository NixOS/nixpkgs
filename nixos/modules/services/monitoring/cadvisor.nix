{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.cadvisor;

in {
  options = {
    services.cadvisor = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = "Whether to enable cadvisor service.";
      };

      listenAddress = mkOption {
        default = "127.0.0.1";
        type = types.str;
        description = "Cadvisor listening host";
      };

      port = mkOption {
        default = 8080;
        type = types.int;
        description = "Cadvisor listening port";
      };

      storageDriver = mkOption {
        default = null;
        type = types.nullOr types.str;
        example = "influxdb";
        description = "Cadvisor storage driver.";
      };

      storageDriverHost = mkOption {
        default = "localhost:8086";
        type = types.str;
        description = "Cadvisor storage driver host.";
      };

      storageDriverDb = mkOption {
        default = "root";
        type = types.str;
        description = "Cadvisord storage driver database name.";
      };

      storageDriverUser = mkOption {
        default = "root";
        type = types.str;
        description = "Cadvisor storage driver username.";
      };

      storageDriverPassword = mkOption {
        default = "root";
        type = types.str;
        description = ''
          Cadvisor storage driver password.

          Warning: this password is stored in the world-readable Nix store. It's
          recommended to use the <option>storageDriverPasswordFile</option> option
          since that gives you control over the security of the password.
          <option>storageDriverPasswordFile</option> also takes precedence over <option>storageDriverPassword</option>.
        '';
      };

      storageDriverPasswordFile = mkOption {
        type = types.str;
        description = ''
          File that contains the cadvisor storage driver password.

          <option>storageDriverPasswordFile</option> takes precedence over <option>storageDriverPassword</option>

          Warning: when <option>storageDriverPassword</option> is non-empty this defaults to a file in the
          world-readable Nix store that contains the value of <option>storageDriverPassword</option>.

          It's recommended to override this with a path not in the Nix store.
          Tip: use <link xlink:href='https://nixos.org/nixops/manual/#idm140737318306400'>nixops key management</link>
        '';
      };

      storageDriverSecure = mkOption {
        default = false;
        type = types.bool;
        description = "Cadvisor storage driver, enable secure communication.";
      };
    };
  };

  config = mkMerge [
    { services.cadvisor.storageDriverPasswordFile = mkIf (cfg.storageDriverPassword != "") (
        mkDefault (toString (pkgs.writeTextFile {
          name = "cadvisor-storage-driver-password";
          text = cfg.storageDriverPassword;
        }))
      );
    }

    (mkIf cfg.enable {
      systemd.services.cadvisor = {
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" "docker.service" "influxdb.service" ];

        postStart = mkBefore ''
          until ${pkgs.curl.bin}/bin/curl -s -o /dev/null 'http://${cfg.listenAddress}:${toString cfg.port}/containers/'; do
            sleep 1;
          done
        '';

        script = ''
          exec ${pkgs.cadvisor}/bin/cadvisor \
            -logtostderr=true \
            -listen_ip="${cfg.listenAddress}" \
            -port="${toString cfg.port}" \
            ${optionalString (cfg.storageDriver != null) ''
              -storage_driver "${cfg.storageDriver}" \
              -storage_driver_user "${cfg.storageDriverHost}" \
              -storage_driver_db "${cfg.storageDriverDb}" \
              -storage_driver_user "${cfg.storageDriverUser}" \
              -storage_driver_password "$(cat "${cfg.storageDriverPasswordFile}")" \
              ${optionalString cfg.storageDriverSecure "-storage_driver_secure"}
            ''}
        '';

        serviceConfig.TimeoutStartSec=300;
      };
      virtualisation.docker.enable = mkDefault true;
    })
  ];
}
