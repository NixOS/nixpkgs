# vmTools {#sec-vm-tools}

A set of VM related utilities, that help in building some packages in more advanced scenarios.

## `vmTools.createEmptyImage` {#vm-tools-createEmptyImage}

A bash script fragment that produces a disk image at `destination`.

### Attributes {#vm-tools-createEmptyImage-attributes}

* `size`. The disk size, in MiB.
* `fullName`. Name that will be written to `${destination}/nix-support/full-name`.
* `destination` (optional, default `$out`). Where to write the image files.

## `vmTools.runInLinuxVM` {#vm-tools-runInLinuxVM}

Run a derivation in a Linux virtual machine (using Qemu/KVM).
By default, there is no disk image; the root filesystem is a `tmpfs`, and the Nix store is shared with the host (via the [9P protocol](https://wiki.qemu.org/Documentation/9p#9p_Protocol)).
Thus, any pure Nix derivation should run unmodified.

If the build fails and Nix is run with the `-K/--keep-failed` option, a script `run-vm` will be left behind in the temporary build directory that allows you to boot into the VM and debug it interactively.

### Attributes {#vm-tools-runInLinuxVM-attributes}

* `preVM` (optional). Shell command to be evaluated *before* the VM is started (i.e., on the host).
* `memSize` (optional, default `512`). The memory size of the VM in MiB (1024×1024 bytes).
* `diskImage` (optional). A file system image to be attached to `/dev/sda`.
  Note that currently we expect the image to contain a filesystem, not a full disk image with a partition table etc.

### Examples {#vm-tools-runInLinuxVM-examples}

Build the derivation hello inside a VM:
```nix
{ pkgs }: with pkgs; with vmTools; runInLinuxVM hello
```

Build inside a VM with extra memory:
```nix
{ pkgs }:
with pkgs;
with vmTools;
runInLinuxVM (
  hello.overrideAttrs (_: {
    memSize = 1024;
  })
)
```

Use VM with a disk image (implicitly sets `diskImage`, see [`vmTools.createEmptyImage`](#vm-tools-createEmptyImage)):
```nix
{ pkgs }:
with pkgs;
with vmTools;
runInLinuxVM (
  hello.overrideAttrs (_: {
    preVM = createEmptyImage {
      size = 1024;
      fullName = "vm-image";
    };
  })
)
```

## `vmTools.extractFs` {#vm-tools-extractFs}

Takes a file, such as an ISO, and extracts its contents into the store.

### Attributes {#vm-tools-extractFs-attributes}

* `file`. Path to the file to be extracted.
  Note that currently we expect the image to contain a filesystem, not a full disk image with a partition table etc.
* `fs` (optional). Filesystem of the contents of the file.

### Examples {#vm-tools-extractFs-examples}

Extract the contents of an ISO file:
```nix
{ pkgs }: with pkgs; with vmTools; extractFs { file = ./image.iso; }
```

## `vmTools.extractMTDfs` {#vm-tools-extractMTDfs}

Like [](#vm-tools-extractFs), but it makes use of a [Memory Technology Device (MTD)](https://en.wikipedia.org/wiki/Memory_Technology_Device).

## `vmTools.runInLinuxImage` {#vm-tools-runInLinuxImage}

Like [](#vm-tools-runInLinuxVM), but instead of using `stdenv` from the Nix store, run the build using the tools provided by `/bin`, `/usr/bin`, etc. from the specified filesystem image, which typically is a filesystem containing a [FHS](https://en.wikipedia.org/wiki/Filesystem_Hierarchy_Standard)-based Linux distribution.

## `vmTools.makeImageTestScript` {#vm-tools-makeImageTestScript}

Generate a script that can be used to run an interactive session in the given image.

### Examples {#vm-tools-makeImageTestScript-examples}

Create a script for running a Fedora 27 VM:
```nix
{ pkgs }: with pkgs; with vmTools; makeImageTestScript diskImages.fedora27x86_64
```

Create a script for running an Ubuntu 20.04 VM:
```nix
{ pkgs }: with pkgs; with vmTools; makeImageTestScript diskImages.ubuntu2004x86_64
```

## `vmTools.diskImageFuns` {#vm-tools-diskImageFuns}

A set of functions that build a predefined set of minimal Linux distributions images.

### Images {#vm-tools-diskImageFuns-images}

* Fedora
  * `fedora26x86_64`
  * `fedora27x86_64`
* CentOS
  * `centos6i386`
  * `centos6x86_64`
  * `centos7x86_64`
* Ubuntu
  * `ubuntu1404i386`
  * `ubuntu1404x86_64`
  * `ubuntu1604i386`
  * `ubuntu1604x86_64`
  * `ubuntu1804i386`
  * `ubuntu1804x86_64`
  * `ubuntu2004i386`
  * `ubuntu2004x86_64`
  * `ubuntu2204i386`
  * `ubuntu2204x86_64`
* Debian
  * `debian10i386`
  * `debian10x86_64`
  * `debian11i386`
  * `debian11x86_64`
  * `debian12i386`
  * `debian12x86_64`

### Attributes {#vm-tools-diskImageFuns-attributes}

* `size` (optional, defaults to `4096`). The size of the image, in MiB.
* `extraPackages` (optional). A list names of additional packages from the distribution that should be included in the image.

### Examples {#vm-tools-diskImageFuns-examples}

8GiB image containing Firefox in addition to the default packages:
```nix
{ pkgs }:
with pkgs;
with vmTools;
diskImageFuns.ubuntu2004x86_64 {
  extraPackages = [ "firefox" ];
  size = 8192;
}
```

## `vmTools.diskImageExtraFuns` {#vm-tools-diskImageExtraFuns}

Shorthand for `vmTools.diskImageFuns.<attr> { extraPackages = ... }`.

## `vmTools.diskImages` {#vm-tools-diskImages}

Shorthand for `vmTools.diskImageFuns.<attr> { }`.
