{ lib, config, pkgs, name, authorities, defaultAuthority, ... }:
let
  inherit (lib)
    attrNames concatLines elemAt escapeShellArg imap1 isList listToAttrs
    mapAttrsToList mergeAttrsList optional pipe mkOption types;
  # Module of options for generated certificate files
  ini = pkgs.formats.ini { };
  toOpenSSLMultiVal = name: list:
    listToAttrs (imap1
      (i: val: {
        name = "${name}.${toString i}";
        value = toString val;
      })
      list);
  toOpenSSLMultiVals = attrs:
    pipe attrs [
      (mapAttrsToList (name: value:
        if (isList value) then
          (toOpenSSLMultiVal name value)
        else {
          ${name} = value;
        }))
      mergeAttrsList
    ];
  file = with types; {
    options = {
      path = mkOption {
        type = path;
        description = "The path to create the file at.";
        example = "/var/lib/myservice/cert.pem";
      };
      owner = mkOption {
        type = str;
        description = "Owner of the created file";
        default = "root";
      };
      group = mkOption {
        type = str;
        description = "Group of the created file";
        default = "root";
      };
      mode = mkOption {
        type = str;
        description = "Octal permissions for the created file";
        default = "0400";
        example = "0440";
      };
    };
  };
  # Options for generated certificate
  request = with types; {
    options = {
      CN = mkOption {
        type = str;
        description = "Certificate Common Name";
        example = "host.network.example";
      };
      hosts = mkOption {
        description = ''
          Subject Alternate Names for the certificate, can be provided as either
          a list of host names or specified by type.
        '';
        type = coercedTo (listOf str) (hosts: { DNS = hosts; }) (submodule {
          options = {
            DNS = mkOption {
              type = listOf str;
              description = "DNS SANs.";
              default = [ ];
            };
            IP = mkOption {
              type = listOf str;
              description = "IP SANs.";
              default = [ ];
            };
          };
        });
        default = { };
      };
      key = mkOption {
        type = attrTag {
          rsa = mkOption {
            type = submodule {
              options.size = mkOption {
                type = ints.positive;
                description = ''
                  RSA key size in bits
                '';
                default = 2048;
              };
            };
            description = "RSA private key";
          };
          ecdsa = mkOption {
            type = submodule {
              options.curve = mkOption {
                type = str;
                description = ''
                  Named elliptic curve to use for key generation.
                  See `openssl ecparam -list_curves`
                '';
                default = "prime256v1";
              };
            };
            description = "Elliptic Curve DSA private key";
          };
        };
        description = ''
          The type of key-pair to generate for the certificate.
          :::{.note}
          The key will be generated at runtime and never exist within the store
          :::
        '';
        default = {
          rsa = {
            size = 2048;
          };
        };
      };
      names = mkOption {
        type = attrsOf str;
        description = "Additional X.509 Subject fields.";
        example = ''
          {
            O = "Example Ltd";
            C = "My Country";
            S = "My State or Province";
          }
        '';
        default = { };
      };
    };
  };
in
{
  options = with types; {
    service = mkOption {
      type = str;
      description = ''
        The systemd service that will become `active` once the certificate is
        installed and ready for use.
        ::: {.note}
        This option is generally set by the authority and should not be
        changed by the user.
        :::
      '';
      default = "certificate@${name}";
    };

    request = mkOption {
      type = submodule request;
      description = ''
        Certificate specification.
        ::: {.note}
        Not all authorities will support all options.
        :::
      '';
    };

    authority = mkOption {
      type = attrTag authorities;
      description = ''
        Authority used to provide the certificate.
      '';
      defaultText = lib.literalExpression
        "config.security.certificates.defaultAuthority";
      default = defaultAuthority;
    };

    certificate = mkOption {
      type = submodule file;
      description = ''
        File to place the public certificate at.
      '';
    };

    private_key = mkOption {
      type = submodule file;
      description = ''
        File to place the private key at.
      '';
    };

    ca = mkOption {
      type = nullOr (submodule file);
      description = ''
        File to place the issuers public certificate at at.
      '';
      default = null;
    };

    # Internal options for use by authorities
    openssl = {
      config = mkOption {
        type = ini.type;
        description = ''
          The resultant CSR structures as a OpenSSL config file. suitable for
          passing to `openssl req`.
          ::: {.note}
          This will typically be used to generate `configFile` and auto
          generated from the certificate specification.
          :::
        '';
        visible = false;
      };

      configFile = mkOption {
        type = path;
        description = ''
          A OpenSSL config file that when passed to `openssl req` will result in
          a "Certificate Signing Request" corresponding to the specification.
          ::: {.note}
          This will typically be auto generated from `config`
          :::
        '';
        visible = false;
      };
    };

    scripts = {
      csr = mkOption {
        type = pathInStore;
        description = ''
          A executable that when run will read the private key on stdin and output
          a Certificate Signing Request on stdout in PEM format.
          ::: {.warn}
          Store objects are world readable and MUST not contain any secrets. As
          such keys and certificates are generated at runtime not buildtime.
          :::
        '';
        visible = false;
      };

      key = mkOption {
        type = pathInStore;
        description = ''
          A executable that when run will produce a private key on stdout in PEM
          format.
          ::: {.warn}
          Store objects are world readable and MUST not contain any secrets. As
          such keys and certificates are generated at runtime not buildtime.
          :::
        '';
      };

      install = mkOption {
        type = pathInStore;
        description = ''
          A executable that takes 3 path arguments to the private key file,
          certificate file, and certificate authority certificate file. Then
          copies those file to their destinations ensuring correct permissions.
        '';
      };
    };
  };

  config = {
    openssl = {
      config =
        let
          dnSect = "${name}_distringished_name";
          extSect = "${name}_extensions";
          sanSect = "${name}_subjectAltName";
        in
        {
          "req" = {
            prompt = "no";
            distinguished_name = dnSect;
            req_extensions = extSect;
          };
          # Distinguished Name
          ${dnSect} = { inherit (config.request) CN; } // config.request.names;
          # Extensions
          ${extSect} = { subjectAltName = "@${sanSect}"; };
          # Subject Alternative Names
          ${sanSect} = toOpenSSLMultiVals config.request.hosts;
        };

      configFile = ini.generate "${name}_csr.cfg" config.openssl.config;
    };
    scripts = {
      csr = pkgs.writeShellScript "${name}-mkcsr" (
        let
          openssl = "${pkgs.openssl}/bin/openssl";
          cfg = config.openssl.configFile;
        in
        ''
          ${openssl} req -config ${cfg} -batch -new -key /dev/stdin -outform PEM
        ''
      );

      key = pkgs.writeShellScript "${name}-mkkey" (
        let
          openssl = "${pkgs.openssl}/bin/openssl";
          inherit (config.request) key;
        in
        if (key ? rsa) then ''
          ${openssl} genrsa ${toString (key.rsa.size or 2048)}
        '' else if (key ? ecdsa) then ''
          ${openssl} ecparam -name ${key.ecdsa.curve} -genkey -outform PEM
        '' else
          abort "Unknown key type: ${elemAt (attrNames key) 0}"
      );

      install = pkgs.writeShellScript "${name}-install" (
        let
          install = src:
            { path, owner ? "$(id -u)", group ? "$(id -g)", mode ? "0600" }:
            "${pkgs.coreutils}/bin/install -Dv " + "-o ${owner} " + "-g ${group} "
            + "-m ${mode} " + "${src} ${escapeShellArg path}";
        in
        concatLines ([
          ''
            PKEY=''${1:-/dev/null}
            CERT=''${2:-/dev/null}
            CA=''${3:-/dev/null}
          ''
        ] ++ (optional (config ? private_key)
          (install "$PKEY" config.private_key))
        ++ (optional (config ? private_key)
          (install "$CERT" config.certificate))
        ++ (optional (config ? ca) (install "$CA" config.ca)))
      );
    };
  };
}
