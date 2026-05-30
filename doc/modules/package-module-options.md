# Bundled Package Modules {#package-module-bundled}

Per-package modules shipped in nixpkgs.

## Services {#package-module-bundled-services}

The following modular services are shipped in nixpkgs. Each is consumed by importing the service module at `system.services.<name>`.
For example, to use `pkgs.ghostunnel.services.default`:

```nix
{
  system.services.ghostunnel = {
    imports = [ pkgs.ghostunnel.services.default ];
    # ghostunnel.package = ...;
    # ...
  };
}
```

@BUNDLED_MODULAR_SERVICES@
