# breakpointHook {#breakpointhook}

This hook will make a build pause instead of stopping when a failure happens. It prevents nix from cleaning up the build environment immediately and allows the user to attach to a build environment using the `cntr` command. Upon build error it will print instructions on how to use `cntr`, which can be used to enter the environment for debugging. Installing cntr and running the command will provide shell access to the build sandbox of failed build. At `/var/lib/cntr` the sandboxed filesystem is mounted. All commands and files of the system are still accessible within the shell. To execute commands from the sandbox use the cntr exec subcommand. `cntr` is only supported on Linux-based platforms. To use it first add `cntr` to your `environment.systemPackages` on NixOS or alternatively to the root user on non-NixOS systems. Then in the package that is supposed to be inspected, add `breakpointHook` to `nativeBuildInputs`.

```nix
nativeBuildInputs = [ breakpointHook ];
```

When a build failure happens there will be an instruction printed that shows how to attach with `cntr` to the build sandbox.

::: {.note}
Caution with remote builds

This won’t work with remote builds as the build environment is on a different machine and can’t be accessed by `cntr`. Remote builds can be turned off by setting `--option builders ''` for `nix-build` or `--builders ''` for `nix build`.
:::
