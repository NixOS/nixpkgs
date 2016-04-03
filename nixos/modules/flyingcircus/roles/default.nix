{ config, lib, pkgs, ... }:

let

  cfg = config.flyingcircus;

  optionalAttr = set: name: default:
    if builtins.hasAttr name set then set.${name} else default;

  enc_roles = optionalAttr cfg.enc "classes" [];

in

{

  imports =
    [
     ./compat.nix
     ./dovecot.nix
     ./generic.nix
     ./haproxy.nix
     ./mailserver.nix
     ./mongodb.nix
     ./mysql.nix
     ./nginx.nix
     ./postgresql.nix
     ./sensuserver.nix
     ./servicecheck.nix
     ./statshost.nix
     ./varnish.nix
    ];

  options = {

    flyingcircus.active-roles = lib.mkOption {
      default = enc_roles;
      type = lib.types.listOf lib.types.str;

      description = ''
        Which roles to activate. E.g:

          flyingcircus.active-roles = [ "generic" "webgateway" "webproxy" ];

        Defaults to the roles provided by the ENC. ENC-provided roles
        will have been stripped the 'role::' prefix automatically.

      '';
    };

  };

  config =
    # Map list of roles to a list of attribute sets enabling each role.
    let
      # Optionally remove the old "role::" prefix from Puppet/ENC
      stripped_roles = map (lib.removePrefix "role::") cfg.active-roles;
      # Turn the list of role names (["a", "b"]) into an attribute set
      # ala { <role> = { enable = true;}; }
      role_set = lib.listToAttrs (
        map (role: { name = role; value = { enable = true; }; })
          stripped_roles);
    in
      {
        flyingcircus.roles = role_set;
      };

}
