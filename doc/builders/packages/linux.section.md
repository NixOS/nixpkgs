# Linux kernel {#sec-linux-kernel}

The Nix expressions to build the Linux kernel are in [`pkgs/os-specific/linux/kernel`](https://github.com/NixOS/nixpkgs/blob/master/pkgs/os-specific/linux/kernel).

The function that builds the kernel has an argument `kernelPatches` which should be a list of `{name, patch, extraConfig}` attribute sets, where `name` is the name of the patch (which is included in the kernel’s `meta.description` attribute), `patch` is the patch itself (possibly compressed), and `extraConfig` (optional) is a string specifying extra options to be concatenated to the kernel configuration file (`.config`).

The kernel derivation exports an attribute `features` specifying whether optional functionality is or isn’t enabled. This is used in NixOS to implement kernel-specific behaviour. For instance, if the kernel has the `iwlwifi` feature (i.e., has built-in support for Intel wireless chipsets), then NixOS doesn’t have to build the external `iwlwifi` package:

```nix
modulesTree = [kernel]
  ++ pkgs.lib.optional (!kernel.features ? iwlwifi) kernelPackages.iwlwifi
  ++ ...;
```

How to add a new (major) version of the Linux kernel to Nixpkgs:

1.  Copy the old Nix expression (e.g., `linux-2.6.21.nix`) to the new one (e.g., `linux-2.6.22.nix`) and update it.

2.  Add the new kernel to the `kernels` attribute set in `linux-kernels.nix` (e.g., create an attribute `kernel_2_6_22`).

3.  Now we’re going to update the kernel configuration. First unpack the kernel. Then for each supported platform (`i686`, `x86_64`, `uml`) do the following:

    1.  Make a copy from the old config (e.g., `config-2.6.21-i686-smp`) to the new one (e.g., `config-2.6.22-i686-smp`).

    2.  Copy the config file for this platform (e.g., `config-2.6.22-i686-smp`) to `.config` in the kernel source tree.

    3.  Run `make oldconfig ARCH={i386,x86_64,um}` and answer all questions. (For the uml configuration, also add `SHELL=bash`.) Make sure to keep the configuration consistent between platforms (i.e., don’t enable some feature on `i686` and disable it on `x86_64`).

    4.  If needed, you can also run `make menuconfig`:

        ```ShellSession
        $ nix-env -f "<nixpkgs>" -iA ncurses
        $ export NIX_CFLAGS_LINK=-lncurses
        $ make menuconfig ARCH=arch
        ```

    5.  Copy `.config` over the new config file (e.g., `config-2.6.22-i686-smp`).

4.  Test building the kernel: `nix-build -A linuxKernel.kernels.kernel_2_6_22`. If it compiles, ship it! For extra credit, try booting NixOS with it.

5.  It may be that the new kernel requires updating the external kernel modules and kernel-dependent packages listed in the `linuxPackagesFor` function in `linux-kernels.nix` (such as the NVIDIA drivers, AUFS, etc.). If the updated packages aren’t backwards compatible with older kernels, you may need to keep the older versions around.
