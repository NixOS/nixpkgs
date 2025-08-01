
# Modular Services

This directory defines a modular service infrastructure for NixOS.
See the [Modular Services chapter] in the manual [[source]](../../doc/manual/development/modular-services.md).

[Modular Services chapter]: https://nixos.org/manual/nixos/unstable/#modular-services

# Design decision log

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

