# Building a NixOS (Live) ISO {#sec-building-image}

Default live installer configurations are available inside `nixos/modules/installer/cd-dvd`.
For building other system images, [nixos-generators] is a good place to start looking at.

You have two options:

- Use any of those default configurations as is
- Combine them with (any of) your host config(s)

System images, such as the live installer ones, know how to enforce configuration settings
on wich they immediately depend in order to work correctly.

However, if you are confident, you can opt to override those
enforced values with `mkForce`.

[nixos-generators]: https://github.com/nix-community/nixos-generators

## Practical Instructions {#sec-building-image-instructions}

```ShellSession
$ git clone https://github.com/NixOS/nixpkgs.git
$ cd nixpkgs/nixos
$ nix-build -A config.system.build.isoImage -I nixos-config=modules/installer/cd-dvd/installation-cd-minimal.nix default.nix
```

To check the content of an ISO image, mount it like so:

```ShellSession
# mount -o loop -t iso9660 ./result/iso/cd.iso /mnt/iso
```

## Technical Notes {#sec-building-image-tech-notes}

The config value enforcement is implemented via `mkImageMediaOverride = mkOverride 60;`
and therefore primes over simple value assignments, but also yields to `mkForce`.

This property allows image designers to implement in semantically correct ways those
configuration values upon which the correct functioning of the image depends.

For example, the iso base image overrides those file systems which it needs at a minimum
for correct functioning, while the installer base image overrides the entire file system
layout because there can't be any other guarantees on a live medium than those given
by the live medium itself. The latter is especially true befor formatting the target
block device(s). On the other hand, the netboot iso only overrides its minimum dependencies
since netboot images are always made-to-target.
