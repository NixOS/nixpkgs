# TODO: Make a utility library of common functions that authorities will want.
{ lib
, config
, options
, pkgs
, ...
}:
let
  inherit (lib)
    attrNames
    mapAttrs'
    mapAttrsToList
    mkOption
    mkOptionDefault
    types
    ;
  # TODO: option names could probably be changed
  top = options.security.certificates;
  cfg = config.security.certificates;

  # collect all the authorities defined under
  # `security.certificates.authorities` and map to their settings
in
{
  options.security.certificates = {
    specifications = mkOption {
      description = ''
        Certificate specifications, certificates defined within here will be
        generated and installed on the host at run time.
      '';
      type = types.attrsOf (types.submoduleWith {
        modules = [
          (import ./specification)
          cfg.authorityModule
          {
            config = {
              _module.args = {
                inherit pkgs;
                inherit (cfg)
                  authorities
                  defaultAuthority;
                lib = lib // {
                  cert = (import ./lib.nix { inherit lib pkgs; });
                };
              };
            };
          }
        ];
      });
      default = { };
    };

    authorityModule = mkOption
      {
        type = types.deferredModule;
        description = ''
          Authority submodules defining per-authority options and settings. The
          module(s) defined here will be included in the specification submodule
        '';
        default = { };
      };

    # For authority collection to work and delegating certificate & authority
    # specific settings the authorities option must be comprised of submodules
    # those submodules must contain a settings option, the type of the settings
    # option can be whatever the author wishes as long as it exists.
    # TODO: There's probably a better way to do this but I haven't figured
    # it out yet.
    authorities = mkOption {
      type = types.submodule { };
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
      type = types.enum (attrNames cfg.authorities);
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
  config = {
    systemd = {
      targets.certificates = {
        wants = mapAttrsToList (_: cert: "${cert.service}.service") cfg.specifications;
        wantedBy = [ "multi-user.target" ];
      };
      services = mapAttrs'
        (name: cert: {
          name = cert.service;
          value = {
            description = "Generate ${name} certificate";
            script = cert.output.scripts.mkCertificate;
            serviceConfig = {
              Type = "oneshot";
              RemainAfterExit = true;
            };
          };
        })
        cfg.specifications;
    };
  };

  meta = {
    maintainers = lib.maintainers.MadnessASAP;
  };
}
