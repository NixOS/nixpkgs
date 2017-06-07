{ config, lib, pkgs, utils, ... }:

with lib;
let

  inherit (pkgs) vault;

  cfg = config.services.vault;
 
  configFile = pkgs.writeText "vault.hcl" ''
    listener "tcp" {
      address = "${cfg.listener.address}"
   
      ${optionalString (cfg.listener.cluster_address != null)''
        cluster_address = "${cfg.listener.cluster_address}"
      ''}
      
      ${optionalString (cfg.listener.tls_cert_file != null)''
        tls_cert_file = "${cfg.listener.tls_cert_file}"
      ''}
      
      ${optionalString (cfg.listener.tls_key_file != null)''
        tls_key_file = "${cfg.listener.tls_key_file}"
      ''}
      
      ${if cfg.listener.tls_disable then "tls_disable = \"1\"" else "" } 

      tls_min_version = "${cfg.listener.tls_min_version}" 


      ${optionalString (cfg.listener.tls_cipher_suites != null)''
        tls_cipher_suites = \"${cfg.listener.tls_cipher_suites}\"
      ''}

      tls_prefer_server_cipher_suites = "${boolToString cfg.listener.tls_prefer_server_cipher_suites}"

      tls_require_and_verify_client_cert = "${boolToString cfg.listener.tls_require_and_verify_client_cert}"

    }

    storage "${cfg.storage.backend}" {
      ${cfg.storage.extraConfig}
    }

    ${if cfg.telemetry.extraConfig != "" then "
      telemetry { 
        ${if cfg.telemetry.disable_hostname then "disable_hostname = \"true\"" else ""}
        ${cfg.telemetry.extraConfig}
      }" else ""}

  '';

in
{
  options = {

    services.vault = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Enables the vault daemon.
        '';
      };

      listener = {

        address = mkOption {
          type = types.str;
          default = "127.0.0.1:8200";
          description = ''
            The name of the ip interface to listen to.
          '';
        };

        cluster_address = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = ''
            The name of the address to bind to for cluster server-to-server requests.
          '';
        };

        tls_cert_file = mkOption {
          type = types.str;
          default = "";
          description = ''
            The name of the crt file for the ssl certificate.
          '';
        };
        
        tls_key_file = mkOption {
          type = types.str;
          default = "";
          description = ''
            The name of the key file for the ssl certificate.
          '';
        };

        tls_disable = mkOption {
          type = types.bool;
          default = false;
          description = ''
            Specifies if TLS will be disabled. Vault assumes TLS by default, so you must explicitly disable TLS to opt-in to insecure communication.
          '';
        };
        
        tls_min_version = mkOption {
          type = types.enum [ "tls10" "tls11" "tls12" ];
          default = "tls12";
          description = ''
             The minimum supported version of TLS. Accepted values are "tls10", "tls11" or "tls12".
          '';
        };

        tls_cipher_suites = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = ''
             The list of supported ciphersuites as a comma-separated-list.
          '';
        };

        tls_prefer_server_cipher_suites = mkOption {
          type = types.bool;
          default = false;
          description = ''
             Specifies to prefer the server's ciphersuite over the client ciphersuites.
          '';
        };

        tls_require_and_verify_client_cert = mkOption {
          type = types.bool;
          default = false;
          description = ''
             Turns on client authentication for this listener.
          '';
        };

      };

      storage = {
    
        backend = mkOption {
          type =  types.str;
          default = "inMemory";
          description = ''
            The name of the type of storage backend.
          '';
        };

        extraConfig = mkOption {
          type = types.lines;
          default = "";
          description = ''
            Configuration for storage
          '';
        };
 
      };


      telemetry = {

        disable_hostname = mkOption {
          type =  types.bool;
          default = false;
          description = ''
            Specifies if gauge values should be prefixed with the local hostname. 
          '';
        };

        extraConfig = mkOption {
          type = types.lines;
          default = "";
          description = ''
            configuration for telemetry
          '';
        };        

      };

    };

  };

  config = mkIf cfg.enable {

    systemd.services.vault =
    { description = "Vault server daemon";

      wantedBy = ["multi-user.target"];

      preStart =
        ''
          mkdir -m 0755 -p /var/lib/vault
        '';

      serviceConfig =
        { ExecStart =
            "${pkgs.vault}/bin/vault server -config ${configFile}";
          KillMode = "process";
        };
    };   
  };

}
