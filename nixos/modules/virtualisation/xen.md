# Xen Project Hypervisor {#module-virtualisation-xen}

## Introduction {#module-virtualisation-xen-introduction}

The [**Xen Project Hypervisor**](https://xenproject.org/) is an open-source
type-1 virtual machine manager which allows multiple virtual machines, known as
*domains*, to run concurrently with the host on the physical machine. This is
unlike a typical type-2 hypervisor, such as QEMU, where the virtual machines run
as applications on top of the host. NixOS runs as the privileged *Domain 0*, and
can paravirtualise (PV Mode) or fully virtualise (HVM Mode) unprivileged domains
(`domUs`).

Xen is security-supported in NixOS. All
[Xen Security Advisories](https://xenbits.xenproject.org/xsa) are patched within
hours of release, and generally reach the binary cache channels within a couple
of days.

## Domain 0 Installation {#module-virtualisation-xen-installation-dom0}

Xen may be used as a Domain 0 since
[NixOS 24.11](#sec-release-24.11-highlights), using the
{option}`virtualisation.xen.enable` option. There are various hardware and
software requirements to running a Xen Domain 0; the module is configured to
prevent running Xen on a NixOS system that does not meet the software
requirements. (i.e. a NixOS system that uses the legacy, scripted initial
ramdisk.) The module does not yet check if the hardware requirements are met:
please manually ensure that the target machine supports
[SLAT](Second_Level_Address_Translation) and
[IOMMU](https://en.wikipedia.org/wiki/Input%E2%80%93output_memory_management_unit),
the latter being required only for non-PV domains to be virtualised.

The boot menu on a Xen-enabled NixOS system will show duplicate entries for each
generation: one boots a normal NixOS system, and the other boots into the Xen
Project Hypervisor. The [`systemd-boot`](#opt-boot.loader.systemd-boot.enable)
and [Limine](#opt-boot.loader.limine.enable) bootloaders are the only supported
boot methods at this time.

Xen may be managed through various frontend configuration systems. `libxenlight`
is one such configuration system, and is built into all Xen systems. The `xl`
command is the primary command-line interface to `libxenlight`, and is capable
of managing a NixOS Domain 0.

## Unprivileged Domain Installation {#module-virtualisation-xen-installation-domU}

Known generically as guests, unprivileged domains running NixOS may import the
[`xen-domU.nix`](https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/virtualisation/xen-domU.nix)
profile in their configurations to automatically enable various recommended
optimisations which are relevant for unprivileged domains.

:::{.example}

# Import the Xen Unprivileged Domain profile into a NixOS configuration

```nix
{
  imports = [
    <nixpkgs/nixos/modules/virtualisation/xen-domU.nix>
  ];
}
```

:::
