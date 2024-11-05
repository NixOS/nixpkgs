{ lib
, config
, pkgs
, ...
}:
let
  inherit (lib)
    filterAttrs
    mapAttrs
    mapAttrs'
    mkMerge
    mkOption
    types
    ;
  lib-cert = import ../lib.nix { inherit lib pkgs; };
  toOpenSSLShell = lib-cert.openssl.toShell;
  cfg = config.security.certificates.authorities.local;
in
{
  options.security.certificates = {
    authorities.local = {
      roots = mkOption {
        type = types.attrsOf
          (
            types.submodule
              ({ name, ... }: {
                options = {
                  CN = mkOption {
                    type = types.str;
                    description = "Common Name";
                  };
                  config = mkOption {
                    type = lib-cert.openssl.config.type;
                    default =
                      let
                        stateDir = "${cfg.stateDirectory}/${name}";
                      in
                      {
                        certificate = "${stateDir}/ca.cert.pem";
                        private_key = "${stateDir}/ca.key.pem";
                        database = "${stateDir}/index.txt";
                        serial = "${stateDir}/serial";
                        new_certs_dir = "${stateDir}";
                        policy = "policy_default";
                        default_md = "sha256";
                        default_days = 365;
                        copy_extensions = "copy";
                      };
                  };
                };
              })
          );
        description = ''
          Certificate Authority roots to generate for signing certificates.
        '';
        default = {
          default = {
            CN = "Self Signed CA";
          };
        };
      };
      stateDirectory =
        mkOption
          {
            type = types.path;
            default = "/var/lib/cert-local";
          };
      config = mkOption {
        type = types.submodule {
          freeformType = lib-cert.openssl.config.type;
        };
      };
      configFile = mkOption {
        type = types.path;
        default = lib-cert.openssl.config.generate cfg.config;
      };
    };
  };
  # TODO: Certificate renewal
  config = {
    systemd.services = mkMerge [
      # Generate all local roots
      (mapAttrs'
        (name: root: {
          name = "certificate-local-${name}";
          value = {
            description = "Generates CA roots for ";
            script = ''
                                          mkdir -m 0700 -p $CA_ROOT/${name}
                                          cd $CA_ROOT/${name}
                                          touch ./index.txt
                                          echo 00 > ./serial
                                          ${toOpenSSLShell "req" {
              config = cfg.configFile;
              x509 = true;
              nodes = true;
              days = 365;
              newkey = "rsa:2048";
              keyout = "ca.key.pem";
              out = "ca.cert.pem";
              subj = "/CN=${root.CN}";
              }}
            '';
            path = [
              pkgs.openssl
              pkgs.util-linux
            ];
            serviceConfig = {
              Type = "oneshot";
              RemainAfterExit = true;
            };
          };
        })
        cfg.roots)
      (mapAttrs'
        (name: cert: {
          name = cert.service;
          value = {
            requires = [ "certificate-local-${cert.authority.local.root}.service" ];
            after = [ "certificate-local-${cert.authority.local.root}.service" ];
          };
        })
        (filterAttrs
          (_: cert: cert.authority ? local)
          config.security.certificates.specifications
        )
      )
    ];
    security.certificates = {
      authorityModule = import ./submodule.nix;
      authorities.local.config = mkMerge [
        {
          req.x509_extensions = "v3_ca";
          policy_default = {
            commonName = "supplied";
            countryName = "optional";
            stateOrProvinceName = "optional";
            organizationName = "optional";
            organizationalUnitName = "optional";
            emailAddress = "optional";
          };
          v3_ca = {
            subjectKeyIdentifier = "hash";
            authorityKeyIdentifier = "keyid:always,issuer";
            basicConstraints = [
              "critical"
              "CA:true"
            ];
            keyUsage = [
              "critical"
              "digitalSignature"
              "cRLSign"
              "keyCertSign"
            ];
          };
        }
      ] ++ (
        mapAttrs (_: root: root.config) cfg.roots
      );

    };
  };
}
