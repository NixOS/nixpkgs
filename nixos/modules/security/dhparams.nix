{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.security.dhparams;

  dhOptions = { ... }: {
    options = {
      service = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          Name of the systemd service (without .service suffix) which uses these DH
          parameters. If not set, parameters name would be used.
        '';
      };

      length = mkOption {
        type = types.int;
        default = 2048;
        description = "Length of generated DH parameters.";
      };

      user = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Owner of generated parameters. If not set, parameters name would be used.";
      };

      group = mkOption {
        type = types.str;
        default = "root";
        description = "Owner group of generated parameters.";
      };

      allowKeysForGroup = mkOption {
        type = types.bool;
        default = false;
        description = "Give read permissions to the specified group to read DH parameters.";
      };
    };
  };

in

{

  ###### interface

  options = {
    security.dhparams = {
      directory = mkOption {
        default = "/var/lib/dhparams";
        type = types.str;
        description = ''
          Directory where generated DH parameters will be stored.
        '';
      };

      params = mkOption {
        default = { };
        type = types.attrsOf (types.submodule dhOptions);
        description = ''
          Attribute set of DH parameters to be generated.
        '';
        example = {
          nginx = { };
          dovecot2 = {
            user = "mail";
            length = 1024;
          };
        };
      };
    };
  };

  ###### implementation
  config = {
    systemd.services =
      let
        svc = name: opts: nameValuePair "dhparams-${name}" {
          description = "Generate Diffie-Hellman parameters for ${name} if they don't exist";
          before = [ "${opts.service}.service" ];
          wantedBy = [ "multi-user.target" ];
          serviceConfig.Type = "oneshot";
          path = [ pkgs.openssl ];
          script = ''
            mkdir -p "${cfg.directory}"
            mkdir -pm${if opts.allowKeysForGroup then "750" else "700"} "${cfg.directory}/${name}"
            if [ ! -e "${cfg.directory}/${name}/dh.pem" ]; then
              openssl dhparam -out "${cfg.directory}/${name}/dh.pem" "${toString opts.length}"
            fi
            chown -R ${opts.user}:${opts.group} "${cfg.directory}/${name}"
          '';
        };

        in mapAttrs' (name: val: svc name (val // {
          service = if val.service == null then name else val.service;
          user = if val.user == null then name else val.user;
        })) cfg.params;

    meta.maintainers = with lib.maintainers; [ abbradar ];
  };

}
