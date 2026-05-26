# Tests in: ../../../../tests/modular-service-etc/test.nix
# Analogous to config-data-path.nix but scoped per user.
# Usage: import ./user-config-data-path.nix userName
userName:
let
  setPathsModule =
    prefix:
    { lib, name, ... }:
    let
      inherit (lib) mkOption types;
      servicePrefix = "${prefix}${name}";
    in
    {
      _class = "service";
      options = {
        configData = mkOption {
          type = types.lazyAttrsOf (
            types.submodule (
              { config, ... }:
              {
                config = {
                  # FIXME use ~/.config/...
                  path = lib.mkDefault "/etc/per-user-services/${userName}/${servicePrefix}/${config.name}";
                };
              }
            )
          );
        };
        services = mkOption {
          type = types.attrsOf (
            types.submoduleWith {
              modules = [ (setPathsModule "${servicePrefix}-") ];
            }
          );
        };
      };
    };
in
setPathsModule ""
