# Testing the Installer {#ch-testing-installer}

Building, burning, and booting from an installation CD is rather
tedious, so here is a quick way to see if the installer works properly:

```ShellSession
# mount -t tmpfs none /mnt
# nixos-generate-config --root /mnt
$ nix-build '<nixpkgs/nixos>' -A config.system.build.nixos-install
# ./result/bin/nixos-install
```

To start a login shell in the new NixOS installation in `/mnt`:

```ShellSession
$ nix-build '<nixpkgs/nixos>' -A config.system.build.nixos-enter
# ./result/bin/nixos-enter
```
