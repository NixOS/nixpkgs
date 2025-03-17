# pkgs.ociTools {#sec-pkgs-ociTools}

`pkgs.ociTools` is a set of functions for creating runtime container bundles according to the [OCI runtime specification v1.2](https://opencontainers.org/posts/blog/2024-02-18-oci-runtime-spec-v1-2/),
also referred to as "OCI Images".

For `ociTools.buildImage`, and `ociTools.buildLayeredImage`, it is a drop-in replacement for [](#sec-pkgs-dockerTools).

## buildImage {#ssec-pkgs-ociTools-buildImage}

This function can be used interchangeably with `dockerTools.buildImage` to build an OCI image.

Additional, OCI-specific arguments can be passed via `extraOCIArgs`. See [](#ssec-pkgs-ociTools-toOCIImage) for a description of what these arguments can be.

### Examples {#ssec-pkgs-ociTools-buildImage-examples}

::: {.example #ex-ociTools-buildImage}
# Creating an OCI image.

This example uses `ociTools.buildImage` to create a simple container that runs `hello`.

```nix
{ pkgs }:
pkgs.ociTools.buildImage {
  name = "hello";
  tag = "latest";
  copyToRoot = [ pkgs.hello ];
  extraOCIArgs.outputFormat = "tarball";
}
```
:::

## buildLayeredImage {#ssec-pkgs-ociTools-buildLayeredImage}

This function can be used interchangeably with `dockerTools.buildLayeredImage` to build an OCI image with the underlying layers being individual Nix store paths.

For the reasons outlined in [](#ssec-pkgs-ociTools-toOCIImage), the store space saving will not be as impactful here as using `dockerTools.buildLayeredImage` directly.

Additional, OCI-specific arguments can be passed via `extraOCIArgs`. See [](#ssec-pkgs-ociTools-toOCIImage) for a description of what these arguments can be.

### Examples {#ssec-pkgs-ociTools-buildLayeredImage-examples}

::: {.example #ex-ociTools-buildLayeredImage}
# Creating a layered OCI Image.

This example uses `ociTools.buildImage` to create a simple container that provides multiple tools `{animal}say` tools.

```nix
{ pkgs }:
pkgs.ociTools.buildLayeredImage {
  name = "animal-sayer";
  tag = "latest";
  copyToRoot = [
    pkgs.cowsay
    pkgs.ponysay
  ];
}
```
:::

## toOCIImage {#ssec-pkgs-ociTools-toOCIImage}

This function is the base of the other OCI image building functions. It converts a Docker-style tarball into an OCI directory or tarball.

Note that due to the nature of `ociTools`, which converts images built with `dockerTools` to OCI images, the image will be kept as:

- The individual layer store paths.
- The resulting Docker-style tarball.
- The resulting OCI directory or tarball.

This makes it less efficient on store space as using `dockerTools` directly.

### Inputs {#ssec-pkgs-ociTools-toOCIImage-inputs}

`toOCIImage` expects an attribute set with the following attributes as its argument:

`docker-tarball` (Path)

: Path of the Docker-style tarball to be converted. In most cases, this will be the
  output of a `dockerTools.*` builder.

`name` (String, _optional_)

: Name of the resulting output path. If not specified, and if the `docker-tarball` input has a `name`
  attribute, this will default to the Docker tarballs' name, with the `.tar.gz` suffix exchanged
  for an `-oci` suffix.

`outputFormat` (String, _optional_)

: Output format of the resulting OCI image. Can either be `directory` (output is an OCI directory) or
  `tarball` (output is an OCI-style tarball).

### Examples {#ssec-pkgs-ociTools-toOCIImage-examples}

::: {.example #ex-ociTools-toOCIImage}
# Converting arbitrary Docker tarballs into OCI images.

This example uses `ociTools.toOCIImage` to convert a Docker-style tarball into an OCI image.

```nix
{ ociTools, dockerTools }:
let
  docker-tarball = pkgs.dockerTools.buildImage {
    name = "hello";
    copyToRoot = [ pkgs.hello ];
  };
in
ociTools.toOCIImage {
  inherit docker-tarball;
  name = "oci-hello";
  outputFormat = "tarball";
}
```
:::

## buildContainer {#ssec-pkgs-ociTools-buildContainer}

:::{.note}
The `buildContainer` interface is deprecated and will be removed in the 25.11 release.

Please use the [](#ssec-pkgs-ociTools-buildImage) interface instead.
:::

This function creates an OCI runtime container (consisting of a `config.json` and a root filesystem directory) that runs a single command inside of it.
The nix store of the container will contain all referenced dependencies of the given command.

This function has an assumption that the container will run on POSIX platforms, and sets configurations (such as the user running the process or certain mounts) according to this assumption.
Because of this, a container built with `buildContainer` will not work on Windows or other non-POSIX platforms without modifications to the container configuration.
These modifications aren't supported by `buildContainer`.

For `linux` platforms, `buildContainer` also configures the following namespaces (see {manpage}`unshare(1)`) to isolate the OCI container from the global namespace:
PID, network, mount, IPC, and UTS.

Note that no user namespace is created, which means that you won't be able to run the container unless you are the `root` user.

### Inputs {#ssec-pkgs-ociTools-buildContainer-inputs}

`buildContainer` expects an argument with the following attributes:

`args` (List of String)

: Specifies a set of arguments to run inside the container.
  Any packages referenced by `args` will be made available inside the container.

`mounts` (Attribute Set; _optional_)

: Would specify additional mounts that the runtime must make available to the container.

  :::{.warning}
  As explained in [issue #290879](https://github.com/NixOS/nixpkgs/issues/290879), this attribute is currently ignored.
  :::

  :::{.note}
  `buildContainer` includes a minimal set of necessary filesystems to be mounted into the container, and this set can't be changed with the `mounts` attribute.
  :::

  _Default value:_ `{}`.

`readonly` (Boolean; _optional_)

: If `true`, sets the container's root filesystem as read-only.

  _Default value:_ `false`.

`os` **DEPRECATED**

: Specifies the operating system on which the container filesystem is based on.
  If specified, its value should follow the [OCI Image Configuration Specification](https://github.com/opencontainers/image-spec/blob/main/config.md#properties).
  According to the linked specification, all possible values for `$GOOS` in [the Go docs](https://go.dev/doc/install/source#environment) should be valid, but will commonly be one of `darwin` or `linux`.

  _Default value:_ `"linux"`.

`arch` **DEPRECATED**

: Used to specify the architecture for which the binaries in the container filesystem have been compiled.
  If specified, its value should follow the [OCI Image Configuration Specification](https://github.com/opencontainers/image-spec/blob/main/config.md#properties).
  According to the linked specification, all possible values for `$GOARCH` in [the Go docs](https://go.dev/doc/install/source#environment) should be valid, but will commonly be one of `386`, `amd64`, `arm`, or `arm64`.

  _Default value:_ `x86_64`.

### Examples {#ssec-pkgs-ociTools-buildContainer-examples}

::: {.example #ex-ociTools-buildContainer-bash}
# Creating an OCI runtime container that runs `bash`

This example uses `ociTools.buildContainer` to create a simple container that runs `bash`.

```nix
{
  ociTools,
  lib,
  bash,
}:
ociTools.buildContainer {
  args = [
    (lib.getExe bash)
  ];

  readonly = false;
}
```

As an example of how to run the container generated by this package, we'll use `runc` to start the container.
Any other tool that supports OCI containers could be used instead.

```shell
$ nix-build
(some output removed for clarity)
/nix/store/7f9hgx0arvhzp2a3qphp28rxbn748l25-join

$ cd /nix/store/7f9hgx0arvhzp2a3qphp28rxbn748l25-join
$ nix-shell -p runc
[nix-shell:/nix/store/7f9hgx0arvhzp2a3qphp28rxbn748l25-join]$ sudo runc run ocitools-example
help
GNU bash, version 5.2.26(1)-release (x86_64-pc-linux-gnu)
(some output removed for clarity)
```
:::
