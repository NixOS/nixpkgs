# breakpointHook {#breakpointhook}

This hook makes a build pause instead of stopping when a failure occurs. It prevents Nix from cleaning up the build environment immediately and allows the user to attach to the build environment. Upon a build error, it will print instructions that can be used to enter the environment for debugging. The `breakpointHook` is only available on Linux. To use it, add `breakpointHook` to `nativeBuildInputs` in the package to be inspected.

```nix
{ nativeBuildInputs = [ breakpointHook ]; }
```

When a build failure occurs, an instruction will be printed showing how to attach to the build sandbox.

::: {.note}
Caution with remote builds

For remote builds, the printed instructions need to be run on the remote machine, as the build sandbox is only accessible on the machine running the builds. Remote builds can be turned off by setting `--option builders ''` for `nix-build` or `--builders ''` for `nix build`. :::
:::
