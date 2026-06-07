# Ad-Hoc Package Management {#sec-ad-hoc-packages}

With the command `nix-env`, you can install and uninstall packages from
the command line. For instance, to install Mozilla Thunderbird:

```ShellSession
$ nix-env -iA nixos.thunderbird
```

If you invoke this as root, the package is installed in the Nix profile
`/nix/var/nix/profiles/default` and visible to all users of the system;
otherwise, the package ends up in
`/nix/var/nix/profiles/per-user/username/profile` and is not visible to
other users. The `-A` flag specifies the package by its attribute name;
without it, the package is installed by matching against its package
name (e.g. `thunderbird`). The latter is slower because it requires
matching against all available Nix packages, and is ambiguous if there
are multiple matching packages.

Packages come from the NixOS channel. You typically upgrade a package by
updating to the latest version of the NixOS channel:

```ShellSession
$ nix-channel --update nixos
```

and then running `nix-env -i` again. Other packages in the profile are
*not* affected; this is the crucial difference with the declarative
style of package management, where running `nixos-rebuild switch` causes
all packages to be updated to their current versions in the NixOS
channel. You can however upgrade all packages for which there is a newer
version by doing:

```ShellSession
$ nix-env -u '*'
```

A package can be uninstalled using the `-e` flag:

```ShellSession
$ nix-env -e thunderbird
```

Finally, you can roll back an undesirable `nix-env` action:

```ShellSession
$ nix-env --rollback
```

`nix-env` has many more flags. For details, see the nix-env(1) manpage or
the Nix manual.
