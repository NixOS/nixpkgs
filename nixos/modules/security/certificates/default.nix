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
        type = attrsOf (submoduleWith {
          modules = [
            (import ./specification.nix)
            {
              config._module.args = { 
                inherit (config.security.certificates) defaultAuthority;
                inherit authorities;
              };
            }
          ];
        });
        default = { };
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
        type = attrTag authorities;
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
          authorities
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
