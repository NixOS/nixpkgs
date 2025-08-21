
# Modular Services

This directory defines a modular service infrastructure for NixOS.
See the [Modular Services chapter] in the manual [[source]](../../doc/manual/development/modular-services.md).

[Modular Services chapter]: https://nixos.org/manual/nixos/unstable/#modular-services

# Design decision log

## Initial design

- `system.services.<name>`. Alternatives considered
  - `systemServices`: similar to does not allow importing a composition of services into `system`. Not sure if that's a good idea in the first place, but I've kept the possibility open.
  - `services.abstract`: used in https://github.com/NixOS/nixpkgs/pull/267111, but too weird. Service modules should fit naturally into the configuration system.
    Also "abstract" is wrong, because it has submodules - in other words, evalModules results, concrete services - not abstract at all.
  - `services.modular`: only slightly better than `services.abstract`, but still weird

- No `daemon.*` options. https://github.com/NixOS/nixpkgs/pull/267111/files#r1723206521

- For now, do not add an `enable` option, because it's ambiguous. Does it disable at the Nix level (not generate anything) or at the systemd level (generate a service that is disabled)?

- Move all process options into a `process` option tree. Putting this at the root is messy, because we also have sub-services at that level. Those are rather distinct. Grouping them "by kind" should raise fewer questions.

- `modules/system/service/systemd/system.nix` has `system` twice. Not great, but
  - they have different meanings
    1. These are system-provided modules, provided by the configuration manager
    2. `systemd/system` configures SystemD _system units_.
  - This reserves `modules/service` for actual service modules, at least until those are lifted out of NixOS, potentially

## Configuration Data (`configData`) Design

Without a mechanism for adding files, all configuration had to go through `process.*`, requiring process restarts even when those would have been avoidable.
Many services implement automatic reloading or reloading on e.g. `SIGUSR1`, but those mechanisms need files to read. `configData` provides such files.

### Naming and Terminology

- **`configData` instead of `environment.etc`**: The name `configData` is service manager agnostic. While systemd system services can use `/etc`, other service managers may expose configuration data differently (e.g., different directory, relative paths).

- **`path` attribute**: Each `configData` entry automatically gets a `path` attribute set by the service manager implementation, allowing services to reference the location of their configuration files. These paths themselves are not subject to change from generation to generation; only their contents are.

- **`name` attribute**: In `environment.etc` this would be `target` but that's confusing, especially for symlinks, as it's not the symlink's target.

### Service Manager Integration

- **Portable base**: The `configData` interface is declared in `portable/config-data.nix`, making it available to all service manager implementations.

- **Systemd integration**: The systemd implementation (`systemd/system.nix`) maps `configData` entries to `environment.etc` entries under `/etc/system-services/`.

- **Path computation**: `systemd/config-data-path.nix` recursively computes unique paths for services and sub-services (e.g., `/etc/system-services/webserver/` vs `/etc/system-services/webserver-api/`).
  Fun fact: for the module system it is a completely normal module, despite its recursive definition.
  If we parameterize `/etc/system-services`, it will have to become an `importApply` style module nonetheless (function returning module).

- **Simple attribute structure**: Unlike `environment.etc`, `configData` uses a simpler structure with just `enable`, `name`, `text`, `source`, and `path` attributes. Complex ownership options were omitted for simplicity and portability.
  Per-service user creation is still TBD.
