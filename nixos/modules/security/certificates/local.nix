{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (pkgs) writeText;
  inherit (lib)
    concatStringsSep
    escapeShellArg
    filterAttrs
    mapAttrs
    mapAttrsToList
    mkMerge
    mkOption
    pipe
    types
    ;
  lib-cert = import ./lib.nix { inherit lib; };
  toOpenSSLShell = lib-cert.openssl.toShell;
  cfg = config.security.certificates.authorities.local;
  modules = with types; {
    root.options = {
      CN = mkOption {
        type = str;
        description = "Common Name";
      };
    };
    settings.options = {
      root = mkOption {
        type = str;
        description = "Root certificate to use.";
        default = "default";
      };
    };
  };
in
{
  options = {
    security.certificates.authorities.local = with types; {
      roots = mkOption {
        type = attrsOf (submodule modules.root);
        description = ''
          Certificate Authority roots to generate for signing certificates.
        '';
        default = {
          default = {
            CN = "Self Signed CA";
          };
        };
      };
      settings = mkOption {
        type = submodule modules.settings;
        description = ''
          Per certificate options specific to the "local" authority.
        '';
        default = { };
      };
    };
  };
  # TODO: Certificate renewal
  config =
    let
      # config sections for defined CA roots
      rootsConfig = mapAttrs (
        name: root:
        let
          dir = "$ENV::STATE_DIRECTORY/${name}";
        in
        {
          certificate = "${dir}/ca.cert.pem";
          private_key = "${dir}/ca.key.pem";
          database = "${dir}/index.txt";
          serial = "${dir}/serial";
          new_certs_dir = "${dir}";
          policy = "policy_default";
          default_md = "sha256";
          default_days = 365;
          copy_extensions = "copy";
        }
      ) cfg.roots;
      # config for signing certificates
      authorityConfig = {
        ca.default_ca = cfg.settings.root;
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
      } // rootsConfig;
      opensslCnf = writeText "cert-local-config" (lib-cert.openssl.toConfigFile { } authorityConfig);
      # base service config
      baseService = {
        wantedBy = [ "multi-user.target" ];
        path = [
          pkgs.openssl
          pkgs.util-linux
        ];
        serviceConfig = rec {
          User = "cert-local";
          DynamicUser = true;
          StateDirectory = User;
          WorkingDirectory = "%S/${StateDirectory}";
          Type = "oneshot";
          RemainAfterExit = true;
        };
      };
    in
    {
      systemd.services = mkMerge (
        # Generate all local roots
        (mapAttrsToList (name: root: {
          "certificate-local@${name}" = mkMerge [
            baseService
            {
              description = "Generates CA roots for ";
              script = ''
                mkdir -m 0700 -p ./${name}
                touch ./${name}/index.txt
                echo 00 > ./${name}/serial
                ${toOpenSSLShell "req" {
                  config = opensslCnf;
                  x509 = true;
                  nodes = true;
                  days = 365;
                  newkey = "rsa:2048";
                  keyout = "${name}/ca.key.pem";
                  out = "${name}/ca.cert.pem";
                  subj = "/CN=${root.CN}";
                }}
              '';
            }
          ];
        }) cfg.roots)
        # Generate requested certificates
        ++ (pipe config.security.certificates.specifications [
          # Get only the specifications with local as the authority
          (filterAttrs (_: spec: spec.authority ? local))
          # Generate services to create the certificates
          (mapAttrsToList (
            name:
            {
              authority,
              service,
              scripts,
              ...
            }:
            let
              inherit (authority.local) root;
              path = file: escapeShellArg "./${name}/${file}";
              key = path "key.pem";
              crt = path "crt.pem";
              ca = escapeShellArg "./${root}/ca.cert.pem";
              signRequest = toOpenSSLShell "ca" {
                config = opensslCnf;
                batch = true;
                name = authority.local.root;
                "in" = "-";
              };
            in
            {
              "${service}" = mkMerge [
                baseService
                {
                  requires = [ "certificate-local@${root}.service" ];
                  after = [ "certificate-local@${root}.service" ];
                  # Certificate generation happens under a DynamicUser with
                  # limited permissions, installation occurs after with root
                  # permissions.
                  script = ''
                    mkdir -m 0700 -p ${path ""}
                    ${scripts.key} > ${key}
                    ${scripts.csr} < ${key} | flock ./lock ${signRequest} > ${crt}
                  '';
                  serviceConfig.ExecStartPost = [ "+${scripts.install} ${key} ${crt} ${ca}" ];
                }
              ];
            }
          ))
        ])
      );
    };
}
