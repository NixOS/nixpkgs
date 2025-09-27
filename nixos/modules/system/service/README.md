
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

## No `pkgs` module argument

The modular service infrastructure avoids exposing `pkgs` as a module argument to service modules. Instead, derivations and builder functions are provided through lexical closure, making dependency relationships explicit and avoiding uncertainty about where dependencies come from.

### Benefits

- **Explicit dependencies**: Services declare what they need rather than implicitly depending on `pkgs`
- **No interference**: Service modules can be reused in different contexts without assuming a specific `pkgs` instance. An unexpected `pkgs` version is not a failure mode anymore.
- **Clarity**: With fewer ways to do things, there's no ambiguity about where dependencies come from (from the module, not the OS or service manager)

### Implementation

- **Portable layer**: Service modules in `portable/` do not receive `pkgs` as a module argument. Any required derivations must be provided by the caller.

- **Systemd integration**: The `systemd/system.nix` module imports `config-data.nix` as a function, providing `pkgs` in lexical closure:
  ```nix
  (import ../portable/config-data.nix { inherit pkgs; })
  ```

- **Service modules**:
  1. Should explicitly declare their package dependencies as options rather than using `pkgs` defaults:
    ```nix
    {
      # Bad: uses pkgs module argument
      foo.package = mkOption {
        default = pkgs.python3;
        # ...
      };
    }
    ```

    ```nix
    {
      # Good: caller provides the package
      foo.package = mkOption {
        type = types.package;
        description = "Python package to use";
        defaultText = lib.literalMD "The package that provided this module.";
      };
    }
    ```

  2. `passthru.services` can still provide a complete module using the package's lexical scope, making the module truly self-contained:

    **Package (`package.nix`):**
    ```nix
    {
      lib,
      writeScript,
      runtimeShell,
    # ... other dependencies
    }:
    stdenv.mkDerivation (finalAttrs: {
      # ... package definition

      passthru.services.default = {
        imports = [
          (lib.modules.importApply ./service.nix {
            inherit writeScript runtimeShell;
          })
        ];
        someService.package = finalAttrs.finalPackage;
      };
    })
    ```

    **Service module (`service.nix`):**
    ```nix
    # Non-module dependencies (importApply)
    { writeScript, runtimeShell }:

    # Service module
    {
      lib,
      config,
      options,
      ...
    }:
    {
      # Service definition using writeScript, runtimeShell from lexical scope
      process.argv = [
        (writeScript "wrapper" ''
          #!${runtimeShell}
          # ... wrapper logic
        '')
        # ... other args
      ];
    }
    ```
