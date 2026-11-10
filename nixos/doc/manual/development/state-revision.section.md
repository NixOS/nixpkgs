# State revision {#sec-state-revision}

NixOS includes a {option}`system.stateVersion` option, used by some modules for a
variety of reasons related to non-backward-compatible changes to software or
the module itself.
Module authors are discouraged from adding new uses of
{option}`system.stateVersion` to their module.

However, when the alternatives are impractical, modules that wish to consume
{option}`system.stateVersion` should instead define their own `stateRevision`
option using `utils.mkStateRevisionOption`.
There should be no uses of `config.system.stateVersion` directly in the module.

(Note the name difference: the {option}`system.stateVersion` option, with a V,
takes a value that looks like "YY.MM".
A `stateRevision` option, with an R, takes a non-negative integer value.)

Modules should also add the value of their `stateRevision` option to
`system.moduleStateRevisions."your.module.stateRevision"`, when the module is
enabled.
This is a purely informative option that exists to help describe the effects of
changing {option}`system.stateVersion`.

Example:

```nix
{
  lib,
  config,
  utils,
  ...
}:
let
  cfg = config.services.whatever;
in
{
  options.services.whatever = {
    enable = lib.mkEnableOption "whatever, a service that does whatever";
    stateRevision = utils.mkStateRevisionOption {
      descriptionName = "the whatever service";
      migrations = {
        "26.05" = "Rename `/var/lib/old_name` to `/var/lib/new_name`.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.whatever = {
      # ...
      serviceConfig.StateDirectory = if cfg.stateRevision < 1 then "old_name" else "new_name";
    };

    # Important: this is inside the `lib.mkIf cfg.enable`
    system.moduleStateRevisions."services.whatever.stateRevision" = cfg.stateRevision;
  };
}
```
