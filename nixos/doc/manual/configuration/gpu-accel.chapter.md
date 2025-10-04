# GPU acceleration {#sec-gpu-accel}

NixOS provides various APIs that benefit from GPU hardware acceleration,
such as VA-API and VDPAU for video playback; OpenGL and Vulkan for 3D
graphics; and OpenCL for general-purpose computing. This chapter
describes how to set up GPU hardware acceleration (as far as this is not
done automatically) and how to verify that hardware acceleration is
indeed used.

Most of the aforementioned APIs are agnostic with regards to which
display server is used. Consequently, these instructions should apply
both to the X Window System and Wayland compositors.

## OpenCL {#sec-gpu-accel-opencl}

[OpenCL](https://en.wikipedia.org/wiki/OpenCL) is a general compute API.
It is used by various applications such as Blender and Darktable to
accelerate certain operations.

OpenCL applications load drivers through the *Installable Client Driver*
(ICD) mechanism. In this mechanism, an ICD file specifies the path to
the OpenCL driver for a particular GPU family. In NixOS, there are two
ways to make ICD files visible to the ICD loader. The first is through
the `OCL_ICD_VENDORS` environment variable. This variable can contain a
directory which is scanned by the ICL loader for ICD files. For example:

```ShellSession
$ export \
  OCL_ICD_VENDORS=`nix-build '<nixpkgs>' --no-out-link -A rocmPackages.clr.icd`/etc/OpenCL/vendors/
```

The second mechanism is to add the OpenCL driver package to
[](#opt-hardware.graphics.extraPackages).
This links the ICD file under `/run/opengl-driver`, where it will be visible
to the ICD loader.

The proper installation of OpenCL drivers can be verified through the
`clinfo` command of the clinfo package. This command will report the
number of hardware devices that is found and give detailed information
for each device:

```ShellSession
$ clinfo | head -n3
Number of platforms  1
Platform Name        AMD Accelerated Parallel Processing
Platform Vendor      Advanced Micro Devices, Inc.
```

### AMD {#sec-gpu-accel-opencl-amd}

Modern AMD [Graphics Core
Next](https://en.wikipedia.org/wiki/Graphics_Core_Next) (GCN) GPUs are
supported through the rocmPackages.clr.icd package. Adding this package to
[](#opt-hardware.graphics.extraPackages)
enables OpenCL support:

```nix
{ hardware.graphics.extraPackages = [ rocmPackages.clr.icd ]; }
```

### Intel {#sec-gpu-accel-opencl-intel}

[Intel Gen12 and later GPUs](https://en.wikipedia.org/wiki/List_of_Intel_graphics_processing_units#Gen12)
are supported by the Intel NEO OpenCL runtime that is provided by the `intel-compute-runtime` package.
The previous generations (8,9 and 11), have been moved to the `intel-compute-runtime-legacy1` package.
The proprietary Intel OpenCL runtime, in the `intel-ocl` package, is an alternative for Gen7 GPUs.

Both `intel-compute-runtime` packages, as well as the `intel-ocl` package can be added to
[](#opt-hardware.graphics.extraPackages)
to enable OpenCL support. For example, for Gen12 and later GPUs, the following
configuration can be used:

```nix
{ hardware.graphics.extraPackages = [ intel-compute-runtime ]; }
```

## Vulkan {#sec-gpu-accel-vulkan}

[Vulkan](https://en.wikipedia.org/wiki/Vulkan_(API)) is a graphics and
compute API for GPUs. It is used directly by games or indirectly though
compatibility layers like
[DXVK](https://github.com/doitsujin/dxvk/wiki).

By default, if [](#opt-hardware.graphics.enable)
is enabled, Mesa is installed and provides Vulkan for supported hardware.

Similar to OpenCL, Vulkan drivers are loaded through the *Installable
Client Driver* (ICD) mechanism. ICD files for Vulkan are JSON files that
specify the path to the driver library and the supported Vulkan version.
All successfully loaded drivers are exposed to the application as
different GPUs. In NixOS, there are two ways to make ICD files visible
to Vulkan applications: an environment variable and a module option.

The way to do this is to add the Vulkan driver package to
[](#opt-hardware.graphics.extraPackages).
This links the ICD file under `/run/opengl-driver`, where it will be
visible to the ICD loader.

The proper installation of Vulkan drivers can be verified through the
`vulkaninfo` command of the vulkan-tools package. This command will
report the hardware devices and drivers found, in this example output
amdvlk and radv:

```ShellSession
$ vulkaninfo | grep GPU
                GPU id  : 0 (Unknown AMD GPU)
                GPU id  : 1 (AMD RADV NAVI10 (LLVM 9.0.1))
     ...
GPU0:
        deviceType     = PHYSICAL_DEVICE_TYPE_DISCRETE_GPU
        deviceName     = Unknown AMD GPU
GPU1:
        deviceType     = PHYSICAL_DEVICE_TYPE_DISCRETE_GPU
```

A simple graphical application that uses Vulkan is `vkcube` from the
vulkan-tools package.

### AMD {#sec-gpu-accel-vulkan-amd}

Modern AMD [Graphics Core
Next](https://en.wikipedia.org/wiki/Graphics_Core_Next) (GCN) GPUs are
supported through the RADV driver, which is part of mesa.

## VA-API {#sec-gpu-accel-va-api}

[VA-API (Video Acceleration API)](https://www.intel.com/content/www/us/en/developer/articles/technical/linuxmedia-vaapi.html)
is an open-source library and API specification, which provides access to
graphics hardware acceleration capabilities for video processing.

VA-API drivers are loaded by `libva`. The version in nixpkgs is built to search
the opengl driver path, so drivers can be installed in
[](#opt-hardware.graphics.extraPackages).

VA-API can be tested using:

```ShellSession
$ nix-shell -p libva-utils --run vainfo
```

### Intel {#sec-gpu-accel-va-api-intel}

Modern Intel GPUs use the iHD driver, which can be installed with:

```nix
{ hardware.graphics.extraPackages = [ intel-media-driver ]; }
```

Older Intel GPUs use the i965 driver, which can be installed with:

```nix
{ hardware.graphics.extraPackages = [ intel-vaapi-driver ]; }
```

## Common issues {#sec-gpu-accel-common-issues}

### User permissions {#sec-gpu-accel-common-issues-permissions}

Except where noted explicitly, it should not be necessary to adjust user
permissions to use these acceleration APIs. In the default
configuration, GPU devices have world-read/write permissions
(`/dev/dri/renderD*`) or are tagged as `uaccess` (`/dev/dri/card*`). The
access control lists of devices with the `uaccess` tag will be updated
automatically when a user logs in through `systemd-logind`. For example,
if the user *alice* is logged in, the access control list should look as
follows:

```ShellSession
$ getfacl /dev/dri/card0
# file: dev/dri/card0
# owner: root
# group: video
user::rw-
user:alice:rw-
group::rw-
mask::rw-
other::---
```

If you disabled (this functionality of) `systemd-logind`, you may need
to add the user to the `video` group and log in again.

### Mixing different versions of nixpkgs {#sec-gpu-accel-common-issues-mixing-nixpkgs}

The *Installable Client Driver* (ICD) mechanism used by OpenCL and
Vulkan loads runtimes into its address space using `dlopen`. Mixing an
ICD loader mechanism and runtimes from different version of nixpkgs may
not work. For example, if the ICD loader uses an older version of glibc
than the runtime, the runtime may not be loadable due to missing
symbols. Unfortunately, the loader will generally be quiet about such
issues.

If you suspect that you are running into library version mismatches
between an ICL loader and a runtime, you could run an application with
the `LD_DEBUG` variable set to get more diagnostic information. For
example, OpenCL can be tested with `LD_DEBUG=files clinfo`, which should
report missing symbols.
