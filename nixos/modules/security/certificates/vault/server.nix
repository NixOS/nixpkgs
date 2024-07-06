{ lib, pkgs, config, ... }:
let
  inherit (lib)
    filterAttrs
    hasSuffix
    mapAttrsToList
    mkIf
    mkMerge
    mkOption
    pipe
    types;
  top = config.security.certificates;
  cfg = top.authorities.vault;
  addr = "http://127.0.0.1:8200";
  token = "/var/lib/vault/.vault-token";
  role = "test";
in
{
  options.security.certificates.authorities.vault.server = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Vault in-memory dev server
        ::: {.warn}
        Intended only for testing/development, do not use in a production environment.
        :::
      '';
    };
  };

  config = mkMerge [
    (mkIf (cfg.server.enable) {
      # Enable the Vault server in dev mode
      services.vault = {
        enable = true;
        dev = true;
      };
      # Configure the vault server with a basic PKI
      systemd.services = {
        # TODO: Send a PR to nixpkgs about this
        vault.serviceConfig.Type = "notify";

        "certificate-vault" = rec {
          wantedBy = [ "multi-user.target" ];
          requiredBy = pipe top.specifications [
            (filterAttrs (_: spec: spec.authority ? vault))
            (filterAttrs (_: spec: spec.authority.vault.role == role))
            (mapAttrsToList (_: cert: "${cert.service}.service"))
          ];
          requires = [ "vault.service" ];
          after = [ "vault.service" ];
          before = requiredBy;

          path = with pkgs; [
            getent
            vault
          ];
          serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
          };
          environment = {
            VAULT_ADDR = addr;
          };
          script = ''
            echo Configuring Vault PKI Server
            export VAULT_TOKEN=$(cat ${token})
            pki_init() {
              vault secrets enable pki  
              vault secrets tune -max-lease-ttl=365d pki
              vault write pki/root/generate/internal          \
                common_name=localhost                         \
                ttl=30d
              vault write pki/config/urls                     \
                issuing_certificates="${addr}/v1/pki/ca"      \
                crl_distribution_points="${addr}/v1/pki/crl"
              vault write pki/roles/${role}                   \
                allowed_domains=test                          \
                allow_subdomains=true                         \
                max_ttl=7d                                    
            }
            log() {
              local level=$1
              while read -r line; do echo "<$level>$line"; done
            }
            pki_init > >(log 7) 2> >(log 4 >&2)
          '';
        };
      };
      # Set the vault authorities defaults for the local dev server
    })
    # Split this part out to prevent an inf-rec
    {
      security.certificates.authorities.vault.settings = mkIf (cfg.server.enable) {
        inherit token role;
      };
    }
  ];
}
