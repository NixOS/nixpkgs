# Writing profiles

When setting an option, use `lib.mkDefault` unless:
- The option *must* be set and the user should get an error if they try to override it.
- The setting should merge with the user's settings (typical for list or set options).

For example:

```nix
{ lib }: {
  # Using mkDefault, because the user might want to disable tlp
  services.tlp.enable = lib.mkDefault true;
  # No need to use mkDefault, because the setting will merge with the user's setting
  boot.kernelModules = [ "tmp_smapi" ];
}
```

Try to avoid "opinionated" settings relating to optional features like sound, bluetooth, choice of bootloader etc.

Where possible, use module imports to share code between similar hardware variants.

# Performance

Profiles should favor usability and stability, so performance improvements should either be conservative or 
be guarded behind additional NixOS module options.

If it makes sense to have a performance-focussed config, it can be declared in a separate profile.

# Testing

Because profiles can only be tested with the appropriate hardware, quality assurance is up to *you*.
