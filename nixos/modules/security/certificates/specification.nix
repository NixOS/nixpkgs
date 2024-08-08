{ lib, name, authorities, defaultAuthority, ... }:
let
  inherit (lib)
    mkOption
    types;
  # Module of options for generated certificate files
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
        type = coercedTo
          (listOf str)
          (hosts: { dns = hosts; })
          (submodule {
            options = {
              dns = mkOption {
                type = listOf str;
                description =
                  "DNS SANs.";
                default = [ ];
              };
              ip = mkOption {
                type = listOf str;
                description =
                  "IP SANs.";
                default = [ ];
              };
            };
          });
        default = { };
      };
      key = {
        algo = mkOption {
          type = enum [ "rsa" "ecdsa" ];
          description = "Key algorithim used to generate private key.";
          defaultText = "Provider dependent";
        };
        size = mkOption {
          type = ints.positive;
          description = "Key length in bits";
          defaultText = "Provider dependent";
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
  };
}
