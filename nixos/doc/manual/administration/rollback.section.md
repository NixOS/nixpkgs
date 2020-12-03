# Rolling Back Configuration Changes {#sec-rollback}

After running `nixos-rebuild` to switch to a new configuration, you may
find that the new configuration doesn't work very well. In that case,
there are several ways to return to a previous configuration.

First, the GRUB boot manager allows you to boot into any previous
configuration that hasn't been garbage-collected. These configurations
can be found under the GRUB submenu "NixOS - All configurations". This
is especially useful if the new configuration fails to boot. After the
system has booted, you can make the selected configuration the default
for subsequent boots:

```ShellSession
# /run/current-system/bin/switch-to-configuration boot
```

Second, you can switch to the previous configuration in a running
system:

```ShellSession
# nixos-rebuild switch --rollback
```

This is equivalent to running:

```ShellSession
# /nix/var/nix/profiles/system-N-link/bin/switch-to-configuration switch
```

where `N` is the number of the NixOS system configuration. To get a
list of the available configurations, do:

```ShellSession
$ ls -l /nix/var/nix/profiles/system-*-link
...
lrwxrwxrwx 1 root root 78 Aug 12 13:54 /nix/var/nix/profiles/system-268-link -> /nix/store/202b...-nixos-13.07pre4932_5a676e4-4be1055
```

Third, you can switch to a specific configuration in a running system:
```ShellSession
# nixos-rebuild switch --generation N
```

This is equivalent to running:
```ShellSession
# /nix/var/nix/profiles/system-N-link/bin/switch-to-configuration switch
```

::: {.note}
`nixos-rebuild-ng` does not support `--generation` yet. If
`system.rebuild.enableNg` is set to `true` in your NixOS configuration, then
you won’t be able to use `--generation`.
:::

To get a list of available generations, you can run
```ShellSession
$ nixos-rebuild list-generations
Generation  Build-date           NixOS version           Kernel   Configuration Revision                    Specialisation
3 current   2025-08-14 18:32:19  25.11.20250814.c0302e0  6.12.41  92ad34354fbe5df2cba094623cb027999b3c712f  *
2           2025-08-14 18:29:46  25.11.20250814.c0302e0  6.12.41  098d5ec67e51391d6ea169e267b620839aa56b8e  *
1           2025-08-14 18:22:18  25.11.20250814.c0302e0  6.12.41  7ee3edc32100cf7bb78030a24a146e802ccec7a7  *
```
