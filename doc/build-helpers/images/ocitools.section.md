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
