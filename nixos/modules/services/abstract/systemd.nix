# This merges systemd support into the generic instance module.
{ lib, config, options, ... }:
let
  inherit (lib) concatMapAttrs mkOption types;

  dash = before: after:
    # maybe add nice clever escaping?
    if after == ""
    then before
    else "${before}-${after}";
in
{
  # First half of the magic: mix systemd logic into the otherwise abstract services
  options = {
    services.abstract = mkOption {
      type = types.lazyAttrsOf (types.submoduleWith { modules = [ ./instance/systemd.nix ]; });
    };
  };

  # Second half of the magic: siphon units that were defined in isolation to the system
  config = {
    systemd.services =
      concatMapAttrs
        (abstractServiceName: abstractServiceConfig:
          if abstractServiceConfig.enable
          then
            concatMapAttrs
              (subServiceName: unitModule: {
                "${dash abstractServiceName subServiceName}" = { ... }: {
                  imports = [ unitModule ];
                };
              })
              abstractServiceConfig.systemd.services
          else {})
        config.services.abstract;

    # systemd.sockets = 
    #   ... same ...

  };
}