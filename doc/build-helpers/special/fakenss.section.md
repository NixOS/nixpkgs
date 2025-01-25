# fakeNss {#sec-fakeNss}

Provides `/etc/passwd` and `/etc/group` files that contain `root` and `nobody`, allowing user/group lookups to work in binaries that insist on doing those.
This might be a better choice than a custom script running `useradd` and related utilities if you only need those files to exist with some entries.

`fakeNss` also provides `/etc/nsswitch.conf`, configuring NSS host resolution to first check `/etc/hosts` before checking DNS, since the default in the absence of a config file (`dns [!UNAVAIL=return] files`) is quite unexpected.

It also creates an empty directory at `/var/empty` because it uses that as the home directory for the `root` and `nobody` users.
The `/var/empty` directory can also be used as a `chroot` target to prevent file access in processes that do not need to access files, if your container runs such processes.

The user entries created by `fakeNss` use the `/bin/sh` shell, which is not provided by `fakeNss` because in most cases it won't be used.
If you need that to be available, see [`dockerTools.binSh`](#sssec-pkgs-dockerTools-helpers-binSh) or provide your own.

## Inputs {#sec-fakeNss-inputs}

`fakeNss` is made available in Nixpkgs as a package rather than a function, but it has two attributes that can be overridden and might be useful in particular cases.
For more details on how overriding works, see [](#ex-fakeNss-overriding) and [](#sec-pkg-override).

`extraPasswdLines` (List of Strings; _optional_)

: A list of lines that will be added to `/etc/passwd`.
  Useful if extra users need to exist in the output of `fakeNss`.
  If `extraPasswdLines` is specified, it will **not** override the `root` and `nobody` entries created by `fakeNss`.
  Those entries will always exist.

  Lines specified here must follow the format in {manpage}`passwd(5)`.

  _Default value:_ `[]`.

`extraGroupLines` (List of Strings; _optional_)

: A list of lines that will be added to `/etc/group`.
  Useful if extra groups need to exist in the output of `fakeNss`.
  If `extraGroupLines` is specified, it will **not** override the `root` and `nobody` entries created by `fakeNss`.
  Those entries will always exist.

  Lines specified here must follow the format in {manpage}`group(5)`.

  _Default value:_ `[]`.

## Examples {#sec-fakeNss-examples}

:::{.example #ex-fakeNss-dockerTools-buildImage}
# Using `fakeNss` with `dockerTools.buildImage`

This example shows how to use `fakeNss` as-is.
It is useful with functions in `dockerTools` to allow building Docker images that have the `/etc/passwd` and `/etc/group` files.
This example includes the `hello` binary in the image so it can do something besides just have the extra files.

```nix
{ dockerTools, fakeNss, hello }:
dockerTools.buildImage {
  name = "image-with-passwd";
  tag = "latest";

  copyToRoot = [ fakeNss hello ];

  config = {
    Cmd = [ "/bin/hello" ];
  };
}
```
:::

:::{.example #ex-fakeNss-overriding}
# Using `fakeNss` with an override to add extra lines

The following code uses `override` to add extra lines to `/etc/passwd` and `/etc/group` to create another user and group entry.

```nix
{ fakeNss }:
fakeNss.override {
  extraPasswdLines = ["newuser:x:9001:9001:new user:/var/empty:/bin/sh"];
  extraGroupLines = ["newuser:x:9001:"];
}
```
:::
