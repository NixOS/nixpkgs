# TODO: Make a utility library of common functions that authorities will want.
{ lib, config, options, ... }:
let
  inherit (lib)
    evalModules
    mapAttrs
    mapAttrsToList
    mkOption
    types;
  # TODO: option names could probably be changed
  top = options.security.certificates;
  modules = with types; rec {
    # Module of options for generated certificate files
    file = {
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
    request = {
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
    # collect all the authorities defined under 
    # `security.certificates.authorities` and map to their settings
    authorities = lib.pipe
      (evalModules {
        modules = top.authorities.type.getSubModules;
      }).options
      [
        (lib.filterAttrs (name: _: name != "_module"))
        (mapAttrs (_: value: value.settings or (mkOption { })))
      ];
    # top certificate specification option
    specification = { name, ... }: {
      options = {
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
          default = config.security.certificates.defaultAuthority;
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
    };
  };
in
{
  options.security.certificates =
    with types;
    {
      specifications = mkOption {
        description = ''
          Certificate specifications, certificates defined within here will be 
          generated and installed on the host at run time.
        '';
        type = attrsOf (submodule modules.specification);
        default = [ ];
      };

      # For authority collection to work and delegating certificate & authority
      # specific settings the authorities option must be comprised of submodules
      # those submodules must contain a settings option, the type of the settings
      # option can be whatever the author wishes as long as it exists.
      # TODO: There's probably a better way to do this but I haven't figured 
      # it out yet.
      authorities = mkOption {
        type = submodule { };
        description = ''
          Authority modules for use in certificate specifications.
          :::{.warn}
          Authorities defined under this must implement a `settings` option,
          it can be of any type but it must exist.
          :::
        '';
        default = { };
      };

      # TODO: Is this a good way to do this? Is a enum str (attrNames authorities)
      # a better way to do this?
      defaultAuthority = mkOption {
        type = attrTag modules.authorities;
        description = ''
          Default certificate authority to use
        '';
        readOnly = true;
      };
    };
  imports = [
    ./local.nix
    ./vault
  ];
  config =
    let
      cfg = config.security.certificates;
    in
    {
      assertions = (
        mapAttrsToList
          (name: settings: {
            assertion = (settings._type or null) == "option";
            message = ''
              security.certificate.authorities.${name}.settings must be declared as
              a option
            '';
          })
          modules.authorities
      );

      systemd.targets = {
        certificates = {
          wants = mapAttrsToList
            (_: cert: "${cert.service}.service")
            cfg.specifications;
          wantedBy = [ "multi-user.target" ];
        };
      };
    };

  meta = {
    maintainers = lib.maintainers.MadnessASAP;
  };
}
