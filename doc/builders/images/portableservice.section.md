# pkgs.portableService {#sec-pkgs-portableService}

`pkgs.portableService` is a function to create _portable service images_,
as read-only, immutable, `squashfs` archives.

systemd supports a concept of [Portable Services](https://systemd.io/PORTABLE_SERVICES/).
Portable Services are a delivery method for system services that uses two specific features of container management:

* Applications are bundled. I.e. multiple services, their binaries and
  all their dependencies are packaged in an image, and are run directly from it.
* Stricter default security policies, i.e. sandboxing of applications.

This allows using Nix to build images which can be run on many recent Linux distributions.

The primary tool for interacting with Portable Services is `portablectl`,
and they are managed by the `systemd-portabled` system service.

::: {.note}
Portable services are supported starting with systemd 239 (released on 2018-06-22).
:::

A very simple example of using `portableService` is described below:

[]{#ex-pkgs-portableService}

```nix
pkgs.portableService {
  pname = "demo";
  version = "1.0";
  units = [ demo-service demo-socket ];
}
```

The above example will build an squashfs archive image in `result/$pname_$version.raw`. The image will contain the
file system structure as required by the portable service specification, and a subset of the Nix store with all the
dependencies of the two derivations in the `units` list.
`units` must be a list of derivations, and their names must be prefixed with the service name (`"demo"` in this case).
Otherwise `systemd-portabled` will ignore them.

::: {.note}
The `.raw` file extension of the image is required by the portable services specification.
:::

Some other options available are:
- `description`, `homepage`

  Are added to the `/etc/os-release` in the image and are shown by the portable services tooling.
  Default to empty values, not added to os-release.
- `symlinks`

  A list of attribute sets {object, symlink}. Symlinks will be created  in the root filesystem of the image to
  objects in the Nix store. Defaults to an empty list.
- `contents`

  A list of additional derivations to be included in the image Nix store, as-is. Defaults to an empty list.
- `squashfsTools`

  Defaults to `pkgs.squashfsTools`, allows you to override the package that provides `mksquashfs`.
- `squash-compression`, `squash-block-size`

  Options to `mksquashfs`. Default to `"xz -Xdict-size 100%"` and `"1M"` respectively.

A typical usage of `symlinks` would be:
```nix
  symlinks = [
    { object = "${pkgs.cacert}/etc/ssl"; symlink = "/etc/ssl"; }
    { object = "${pkgs.bash}/bin/bash"; symlink = "/bin/sh"; }
    { object = "${pkgs.php}/bin/php"; symlink = "/usr/bin/php"; }
  ];
```
to create these symlinks for legacy applications that assume them existing globally.

Once the image is created, and deployed on a host in `/var/lib/portables/`, you can attach the image and run the service. As root run:
```console
portablectl attach demo_1.0.raw
systemctl enable --now demo.socket
systemctl enable --now demo.service
```
::: {.note}
See the [man page](https://www.freedesktop.org/software/systemd/man/portablectl.html) of `portablectl` for more info on its usage.
:::
