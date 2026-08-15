# Building Specific Parts of NixOS {#sec-building-parts}

With the command `nix-build`, you can build specific parts of your NixOS
configuration. This is done as follows:

```ShellSession
$ cd /path/to/nixpkgs/nixos
$ nix-build -A config.option
```

where `option` is a NixOS option with type "derivation" (i.e. something
that can be built). Attributes of interest include:

`system.build.toplevel`

:   The top-level option that builds the entire NixOS system. Everything
    else in your configuration is indirectly pulled in by this option.
    This is what `nixos-rebuild` builds and what `/run/current-system`
    points to afterwards.

    A shortcut to build this is:

    ```ShellSession
    $ nix-build -A system
    ```

`system.build.manual.manualHTML`

:   The NixOS manual.

`system.build.etc`

:   A tree of symlinks that form the static parts of `/etc`.

`system.build.initialRamdisk` , `system.build.kernel`

:   The initial ramdisk and kernel of the system. This allows a quick
    way to test whether the kernel and the initial ramdisk boot
    correctly, by using QEMU's `-kernel` and `-initrd` options:

    ```ShellSession
    $ nix-build -A config.system.build.initialRamdisk -o initrd
    $ nix-build -A config.system.build.kernel -o kernel
    $ qemu-system-x86_64 -kernel ./kernel/bzImage -initrd ./initrd/initrd -hda /dev/null
    ```

`system.build.nixos-rebuild` , `system.build.nixos-install` , `system.build.nixos-generate-config`

:   These build the corresponding NixOS commands.

`systemd.units.unit-name.unit`

:   This builds the unit with the specified name. Note that since unit
    names contain dots (e.g. `httpd.service`), you need to put them
    between quotes, like this:

    ```ShellSession
    $ nix-build -A 'config.systemd.units."httpd.service".unit'
    ```

    You can also test individual units, without rebuilding the whole
    system, by putting them in `/run/systemd/system`:

    ```ShellSession
    $ cp $(nix-build -A 'config.systemd.units."httpd.service".unit')/httpd.service \
        /run/systemd/system/tmp-httpd.service
    # systemctl daemon-reload
    # systemctl start tmp-httpd.service
    ```

    Note that the unit must not have the same name as any unit in
    `/etc/systemd/system` since those take precedence over
    `/run/systemd/system`. That's why the unit is installed as
    `tmp-httpd.service` here.
