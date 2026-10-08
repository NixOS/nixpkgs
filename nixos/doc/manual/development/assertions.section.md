# Warnings and Assertions {#sec-assertions}

When configuration problems are detectable in a module, it is a good idea to write an assertion or warning. Doing so provides clear feedback to the user and prevents errors after the build.

Although Nix has the `abort` and `builtins.trace` [functions](https://nixos.org/nix/manual/#ssec-builtins) to perform such tasks, they are not ideally suited for NixOS modules. Instead of these functions, you can declare your warnings and assertions using the NixOS module system.

## Warnings {#sec-assertions-warnings}

This is an example of using `warnings`.

```nix
{ config, lib, ... }:
{
  config = lib.mkIf config.services.foo.enable {
    warnings =
      if config.services.foo.bar then
        [
          ''
            You have enabled the bar feature of the foo service.
                           This is known to cause some specific problems in certain situations.
          ''
        ]
      else
        [ ];
  };
}
```

## Assertions {#sec-assertions-assetions}

This example, extracted from the [`syslogd` module](https://github.com/NixOS/nixpkgs/blob/release-17.09/nixos/modules/services/logging/syslogd.nix) shows how to use `assertions`. Since there can only be one active syslog daemon at a time, an assertion is useful to prevent such a broken system from being built.

```nix
{ config, lib, ... }:
{
  config = lib.mkIf config.services.syslogd.enable {
    assertions = [
      {
        assertion = !config.services.rsyslogd.enable;
        message = "rsyslogd conflicts with syslogd";
      }
    ];
  };
}
```
