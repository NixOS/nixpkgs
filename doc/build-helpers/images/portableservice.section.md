# pkgs.portableService {#sec-pkgs-portableService}

`pkgs.portableService` is a function to create [Portable Services](https://systemd.io/PORTABLE_SERVICES/) in a read-only, immutable, `squashfs` raw disk image.
This lets you use Nix to build images which can be run on many recent Linux distributions.

::: {.note}
Portable services are supported starting with systemd 239 (released on 2018-06-22).
:::

The generated image will contain the file system structure as required by the Portable Services specification, along with the packages given to `portableService` and all of their dependencies.
When generated, the image will exist in the Nix store with the `.raw` file extension, as required by the specification.
See [](#ex-portableService-hello) to understand how to use the output of `portableService`.

## Inputs {#ssec-pkgs-portableService-inputs}

`portableService` expects one argument with the following attributes:

`pname` (String)

: The name of the portable service.
  The generated image will be named according to the template `$pname_$version.raw`, which is supported by the Portable Services specification.

`version` (String)

: The version of the portable service.
  The generated image will be named according to the template `$pname_$version.raw`, which is supported by the Portable Services specification.

`units` (List of Attribute Set)

: A list of derivations for systemd unit files.
  Each derivation must produce a single file, and must have a name that starts with the value of `pname` and ends with the suffix of the unit type (e.g. ".service", ".socket", ".timer", and so on).
  See [](#ex-portableService-hello) to better understand this naming constraint.

`description` (String or Null; _optional_)

: If specified, the value is added as `PORTABLE_PRETTY_NAME` to the `/etc/os-release` file in the generated image.
  This could be used to provide more information to anyone inspecting the image.

  _Default value:_ `null`.

`homepage` (String or Null; _optional_)

: If specified, the value is added as `HOME_URL` to the `/etc/os-release` file in the generated image.
  This could be used to provide more information to anyone inspecting the image.

  _Default value:_ `null`.

`symlinks` (List of Attribute Set; _optional_)

: A list of attribute sets in the format `{object, symlink}`.
  For each item in the list, `portableService` will create a symlink in the path specified by `symlink` (relative to the root of the image) that points to `object`.

  All packages that `object` depends on and their dependencies are automatically copied into the image.

  This can be used to create symlinks for applications that assume some files to exist globally (`/etc/ssl` or `/bin/bash`, for example).
  See [](#ex-portableService-symlinks) to understand how to do that.

  _Default value:_ `[]`.

`contents` (List of Attribute Set; _optional_)

: A list of additional derivations to be included as-is in the image.
  These derivations will be included directly in a `/nix/store` directory inside the image.

  _Default value:_ `[]`.

`squashfsTools` (Attribute Set; _optional_)

: Allows you to override the package that provides {manpage}`mksquashfs(1)`, which is used internally by `portableService`.

  _Default value:_ `pkgs.squashfsTools`.

`squash-compression` (String; _optional_)

: Passed as the compression option to {manpage}`mksquashfs(1)`, which is used internally by `portableService`.

  _Default value:_ `"xz -Xdict-size 100%"`.

`squash-block-size` (String; _optional_)

: Passed as the block size option to {manpage}`mksquashfs(1)`, which is used internally by `portableService`.

  _Default value:_ `"1M"`.

## Examples {#ssec-pkgs-portableService-examples}

[]{#ex-pkgs-portableService}
:::{.example #ex-portableService-hello}
# Building a Portable Service image

The following example builds a Portable Service image with the `hello` package, along with a service unit that runs it.

```nix
{
  lib,
  writeText,
  portableService,
  hello,
}:
let
  hello-service = writeText "hello.service" ''
    [Unit]
    Description=Hello world service

    [Service]
    Type=oneshot
    ExecStart=${lib.getExe hello}
  '';
in
portableService {
  pname = "hello";
  inherit (hello) version;
  units = [ hello-service ];
}
```

After building the package, the generated image can be loaded into a system through {manpage}`portablectl(1)`:

```shell
$ nix-build
(some output removed for clarity)
/nix/store/8c20z1vh7z8w8dwagl8w87b45dn5k6iq-hello-img-2.12.1

$ portablectl attach /nix/store/8c20z1vh7z8w8dwagl8w87b45dn5k6iq-hello-img-2.12.1/hello_2.12.1.raw
Created directory /etc/systemd/system.attached.
Created directory /etc/systemd/system.attached/hello.service.d.
Written /etc/systemd/system.attached/hello.service.d/20-portable.conf.
Created symlink /etc/systemd/system.attached/hello.service.d/10-profile.conf → /usr/lib/systemd/portable/profile/default/service.conf.
Copied /etc/systemd/system.attached/hello.service.
Created symlink /etc/portables/hello_2.12.1.raw → /nix/store/8c20z1vh7z8w8dwagl8w87b45dn5k6iq-hello-img-2.12.1/hello_2.12.1.raw.

$ systemctl start hello
$ journalctl -u hello
Feb 28 22:39:16 hostname systemd[1]: Starting Hello world service...
Feb 28 22:39:16 hostname hello[102887]: Hello, world!
Feb 28 22:39:16 hostname systemd[1]: hello.service: Deactivated successfully.
Feb 28 22:39:16 hostname systemd[1]: Finished Hello world service.

$ portablectl detach hello_2.12.1
Removed /etc/systemd/system.attached/hello.service.
Removed /etc/systemd/system.attached/hello.service.d/10-profile.conf.
Removed /etc/systemd/system.attached/hello.service.d/20-portable.conf.
Removed /etc/systemd/system.attached/hello.service.d.
Removed /etc/portables/hello_2.12.1.raw.
Removed /etc/systemd/system.attached.
```
:::

:::{.example #ex-portableService-symlinks}
# Specifying symlinks when building a Portable Service image

Some services may expect files or directories to be available globally.
An example is a service which expects all trusted SSL certificates to exist in a specific location by default.

To make things available globally, you must specify the `symlinks` attribute when using `portableService`.
The following package builds on the package from [](#ex-portableService-hello) to make `/etc/ssl` available globally (this is only for illustrative purposes, because `hello` doesn't use `/etc/ssl`).

```nix
{
  lib,
  writeText,
  portableService,
  hello,
  cacert,
}:
let
  hello-service = writeText "hello.service" ''
    [Unit]
    Description=Hello world service

    [Service]
    Type=oneshot
    ExecStart=${lib.getExe hello}
  '';
in
portableService {
  pname = "hello";
  inherit (hello) version;
  units = [ hello-service ];
  symlinks = [
    {
      object = "${cacert}/etc/ssl";
      symlink = "/etc/ssl";
    }
  ];
}
```
:::
