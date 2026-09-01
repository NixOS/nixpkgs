# Analogous to ../system/config-data-path.nix but scoped per user.
# Usage: import ./config-data-path.nix userName
#
# configData paths land under the per-user profile:
#   /etc/profiles/per-user/$USER/etc/xdg/user-services/...
# which is in $XDG_CONFIG_DIRS (boot/systemd/user.nix wires this in).
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
                  path = lib.mkDefault "/etc/profiles/per-user/${userName}/etc/xdg/user-services/${servicePrefix}/${config.name}";
                };
              }
            )
          );
        };
        services = mkOption {
          type = types.attrsOf (
            types.submoduleWith {
              modules = [
                (setPathsModule "${servicePrefix}-")
              ];
            }
          );
        };
      };
    };
in
setPathsModule ""
