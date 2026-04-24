# State version {#sec-state-version}

NixOS includes a {option}`system.stateVersion` option, used by some modules for a
variety of reasons related to non-backward-compatible changes to software or
the module itself.
Module authors are discouraged from adding new uses of
{option}`system.stateVersion` to their module.

However, when the alternatives are impractical, modules that wish to consume
{option}`system.stateVersion` should instead define their own `stateVersion`
option using `lib.mkStateVersionOption`.
There should be no uses of `config.system.stateVersion` directly in the module.

Modules should also add the value of their `stateVersion` option to
`system.moduleStateVersions."your.module.stateVersion"`, when the module is
enabled.
This is a purely informative option that exists to help describe the effects of
changing {option}`system.stateVersion`.

Example:

```nix
{ lib, config, ... }:
let
  cfg = config.services.whatever;
in
{
  options.services.whatever = {
    enable = lib.mkEnableOption "whatever, a service that does whatever";
    stateVersion = lib.mkStateVersionOption config "the whatever service" {
      "26.05" = "Rename `/var/lib/old_name` to `/var/lib/new_name`.";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.whatever = {
      # ...
      serviceConfig.StateDirectory = if cfg.stateVersion < 1 then "old_name" else "new_name";
    };

    # Important: this is inside the `lib.mkIf cfg.enable`
    system.moduleStateVersions."services.whatever.stateVersion" = cfg.stateVersion;
  };
}
```
