# Package Modules {#package-modules}

Nixpkgs ships modules under `pkgs.<pkg>.<category>`, available to any module-system consumer:
NixOS, Home Manager, nix-darwin, or any custom `evalModules` context.

Currently defined categories:

- `services` ([modular services](#modular-services)): portable, composable service modules.

```{=include=} sections
modular-services.section.md
```
