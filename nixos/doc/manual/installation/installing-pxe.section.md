# Booting from the "netboot" media (PXE) {#sec-booting-from-pxe}

Advanced users may wish to install NixOS using an existing PXE or iPXE
setup.

These instructions assume that you have an existing PXE or iPXE
infrastructure and want to add the NixOS installer as another
option. To build the necessary files from your current version of nixpkgs,
you can run:

```ShellSession
nix-build -A netboot.x86_64-linux '<nixpkgs/nixos/release.nix>'
```

This will create a `result` directory containing:

* `bzImage` -- the Linux kernel
* `initrd` -- the initrd file
* `netboot.ipxe` -- an example ipxe script demonstrating the appropriate kernel command line arguments for this image

If you're using plain PXE, configure your boot loader to use the
`bzImage` and `initrd` files and have it provide the same kernel command
line arguments found in `netboot.ipxe`.

If you're using iPXE, depending on how your HTTP/FTP/etc. server is
configured you may be able to use `netboot.ipxe` unmodified, or you may
need to update the paths to the files to match your server's directory
layout.

In the future we may begin making these files available as build
products from hydra at which point we will update this documentation
with instructions on how to obtain them either for placing on a
dedicated TFTP server or to boot them directly over the internet.
