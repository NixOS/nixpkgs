# Binaries from other distributions {#sec-fhs}

Software packaged in Nixpkgs is built to be platform-agnostic in the sense that
it doesn't expect any dependencies to be implicitly provided by the host
environment. If a Nix-built program needs to load dynamic shared libraries, the
concrete revisions of these libraries are always deployed with the program in
predictable locations. This way, a program built by Nix can be run on any other
machine with the same architecture, regardless of the environment. For example,
such a program doesn't need global paths like `/bin` or `/usr/lib` to exist,
and it always loads the same versions of its dependencies.
This determinism has known limits, cf. [](#sec-fhs-drivers).

Programs distributed in the binary form outside Nixpkgs will often expect to
find their dependencies in some of the several common global locations.
Specifically they would expect to be run in the so-called "merged FHS
environment" (for [Filesystem Hierarchy
Standard](https://en.wikipedia.org/wiki/Filesystem_Hierarchy_Standard)). This
concerns software downloaded using `pip` or `conda install`, toolchains fetched
by build systems such as `gradle`, shell scripts with hard-coded paths, or
anything downloaded from the web.

In Nixpkgs the "FHS" hierarchy is splayed, rather than merged: every revision
of a program is installed into its own prefix. NixOS does not materialize this
hierarchy into any global paths, meaning that the user wishing to run a program
expecting the "FHS" environment needs to explicitly point the program at its
dependencies. NixOS provides several tools that automate or otherwise
accommodate this task.

## Dynamic linkage issues {#sec-fhs-dynamic-linkage}

Dynamically linked native programs built for "FHS" environments expect to find
the so-called "dynamic linker" in a fixed location, e.g.
`/lib64/ld-linux-x86-64.so.2` depending on the platform.
In nixpkgs on the other hand the same binary will have the linker hard-coded
to a specific glibc package in the nix store
(i.e. `/nix/store/00000000000000000000000000000000-glibc-2.xx-xx/lib/ld-linux-x86-64.so.2`).
They might also expect a number of "system" libraries to be provided by the environment.
In "FHS" distributions these are deployed in `/usr/lib`, and paths to them are
discovered by the dynamic linker through the `/etc/ld.so.conf` file. These
files are not available in NixOS by default.

NixOS provides the [](#opt-programs.nix-ld.enable) option which deploys a proxy where
"FHS" distributions deploy the dynamic linker (e.g.
`/lib64/ld-linux-x86-64.so.2`). This proxy allows the user to redirect "FHS"
programs to the "system dependencies" they expect using the `NIX_LD` and
`NIX_LD_LIBRARY_PATH` variables. These variables are safe in that they do not
affect software from Nixpkgs. The `nix-ld` NixOS module also sets up default
values for these variables.

For example, with the following configuration:

```nix
  programs.nix-ld.enable = true;
```

...packages from conda can be used as follows:

```bash
$ nix-shell -p micromamba
$ micromamba env create -n some-env python pytorch
$ eval "$(micromamba shell hook --shell=bash)"
$ micromamba activate some-env
$ python
>>> import torch
```

Without `nix-ld` it wouldn't be possible to run the conda-installed python
interpreter, because it wouldn't know where to find the dynamic linker:

```bash
$ micromamba activate some-env
$ python
bash: /home/nixos/micromamba/envs/some-env/bin/python: cannot execute: required file not found
$ patchelf --print-interpreter $(which python)
/lib64/ld-linux-x86-64.so.2
```

Similarly, native libraries installed from binaries may be used with `nix-ld`:

```bash
$ python -m venv ~/some-venv
$ source ~/some-venv/bin/activate
$ pip install zmq
$ python
>>> import zmq
```

Without `nix-ld` the above would have failed:

```bash
$ source ~/some-venv/bin/activate
$ python
>>> import zmq
...
ImportError: libstdc++.so.6: cannot open shared object file: No such file or directory
```

A more complex scenario may be handled using ad hoc Nix shells:

```nix
# shell.nix

with import <nixpkgs> { };

mkShell {
    packages = [ micromamba ];
    NIX_LD_LIBRARY_PATH = lib.makeSearchPath "lib" [
      addOpenGLRunpath.driverLink # "/run/opengl-driver"
      glib.out
      libglvnd
      stdenv.cc.cc.lib
    ];
}
```

```bash
$ nix-shell shell.nix
$ micromamba env create -n omnimotion python=3.8
$ eval "$(micromamba shell hook --shell=bash)"
$ micromamba activate omnimotion
$ micromamba install ...
$ pip install ...
```

## General missing paths issues {#sec-fhs-missing-paths}

Software built for "FHS" environments might sometimes also access other
executables by their global "FHS" paths, instead of relying on the `PATH`
variable and accessing them by name. E.g. it is common for shell scripts to
start with a shebang like `#!/bin/bash` instead of `#!/usr/bin/env bash`. NixOS
does not, by default, deploy `/bin/bash`, but it does deploy `/usr/bin/env`
which can find `bash` using the `PATH` environment variable.

NixOS provides the `services.envfs.enable` option for mounting a virtual
filesystem in `/bin` and `/usr/bin`, which would resolve attempts at opening
files in global locations (like `/bin/bash`) based on the `PATH` variable of
the calling process:

```nix
  services.envfs.enable = true;
```

## Simulating an "FHS" environment {#sec-fhs-containers}

Nixpkgs also provide tools for composing packages into a merged file tree. It
is also possible to present this merged tree to "FHS" programs as overlaid on
top of the real file system using the kernel feature called "user namespaces".
This can be used to run "FHS" programs on NixOS Cf. [the Nixpkgs
manual](https://nixos.org/manual/nixpkgs/unstable/#sec-fhs-environments)

## Graphics driver libraries {#sec-fhs-graphics-drivers}

For certain libraries it isn't practical to link them directly like Nixpkgs do,
because of their relation to hardware and the kernel. This includes graphics
(OpenGL, Vulkan) and GPGPU compute (CUDA, ROCm) userspace drivers. These
userspace drivers are special dynamic shared libraries that are deployed and
updated with the respective kernel modules. Instead of linking concrete
versions of kernel-specific drivers, Nixpkgs software expects to find the
host-specific drivers in a fixed global location (currently
`/run/opengl-driver/lib`), or to be communicated a different location using the
`LD_LIBRARY_PATH` variable.

NixOS deploys the GPU drivers in the location expected by Nixpkgs. Software
from other distributions, such as installed by `pip`, may not be aware of this
NixOS-specific path. In this case the user may communicate the location of the
drivers using the `NIX_LD_LIBRARY_PATH` environment variable (`LD_LIBRARY_PATH`
if not using `nix-ld`, cf [](#sec-fhs-dynamic-linkage)):

```nix
# /etc/nixos/configuration.nix
  hardware.opengl.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  programs.nix-ld.enable = true;
```

```nix
# shell.nix

with import <nixpkgs> { };

mkShell {
    packages = [ micromamba ];
    NIX_LD_LIBRARY_PATH = lib.makeSearchPath "lib" [
      addOpenGLRunpath.driverLink # "/run/opengl-driver"
      stdenv.cc.cc.lib
    ];
}
```

```bash
$ nix-shell
$ micromamba env create -n some-env python pytorch
$ eval "$(micromamba shell hook --shell=bash)"
$ micromamba activate some-env
$ python
>>> import torch
>>> torch.cuda.is_available()
True
```

to [](#sec-gpu-accel).
