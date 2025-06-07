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
To get a list of available generations, you can run
```ShellSession
$ nixos-rebuild list-generations
Generation      Build-date               NixOS version           Kernel  Configuration Revision                    Specialisations
...
52   (current)  Fri 2023-08-18 08:17:27  23.11.20230817.0f46300  6.4.10  448160aeccf6a7184bd8a84290d527819f1c552c  *
51              Mon 2023-08-07 17:56:41  23.11.20230807.31b1eed  6.4.8   99ef480007ca51e3d440aa4fa6558178d63f9c42  *
```
