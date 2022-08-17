# pkgs.dockerTools {#sec-pkgs-dockerTools}

`pkgs.dockerTools` is a set of functions for creating and manipulating Docker images according to the [Docker Image Specification v1.2.0](https://github.com/moby/moby/blob/master/image/spec/v1.2.md#docker-image-specification-v120). Docker itself is not used to perform any of the operations done by these functions.

## buildImage {#ssec-pkgs-dockerTools-buildImage}

This function is analogous to the `docker build` command, in that it can be used to build a Docker-compatible repository tarball containing a single image with one or multiple layers. As such, the result is suitable for being loaded in Docker with `docker load`.

The parameters of `buildImage` with relative example values are described below:

[]{#ex-dockerTools-buildImage}
[]{#ex-dockerTools-buildImage-runAsRoot}

```nix
buildImage {
  name = "redis";
  tag = "latest";

  fromImage = someBaseImage;
  fromImageName = null;
  fromImageTag = "latest";

  copyToRoot = pkgs.buildEnv {
    name = "image-root";
    paths = [ pkgs.redis ];
    pathsToLink = [ "/bin" ];
  };

  runAsRoot = ''
    #!${pkgs.runtimeShell}
    mkdir -p /data
  '';

  config = {
    Cmd = [ "/bin/redis-server" ];
    WorkingDir = "/data";
    Volumes = { "/data" = { }; };
  };

  diskSize = 1024;
  buildVMMemorySize = 512;
}
```

The above example will build a Docker image `redis/latest` from the given base image. Loading and running this image in Docker results in `redis-server` being started automatically.

- `name` specifies the name of the resulting image. This is the only required argument for `buildImage`.

- `tag` specifies the tag of the resulting image. By default it's `null`, which indicates that the nix output hash will be used as tag.

- `fromImage` is the repository tarball containing the base image. It must be a valid Docker image, such as exported by `docker save`. By default it's `null`, which can be seen as equivalent to `FROM scratch` of a `Dockerfile`.

- `fromImageName` can be used to further specify the base image within the repository, in case it contains multiple images. By default it's `null`, in which case `buildImage` will peek the first image available in the repository.

- `fromImageTag` can be used to further specify the tag of the base image within the repository, in case an image contains multiple tags. By default it's `null`, in which case `buildImage` will peek the first tag available for the base image.

- `copyToRoot` is a derivation that will be copied in the new layer of the resulting image. This can be similarly seen as `ADD contents/ /` in a `Dockerfile`. By default it's `null`.

- `runAsRoot` is a bash script that will run as root in an environment that overlays the existing layers of the base image with the new resulting layer, including the previously copied `contents` derivation. This can be similarly seen as `RUN ...` in a `Dockerfile`.

> **_NOTE:_** Using this parameter requires the `kvm` device to be available.

- `config` is used to specify the configuration of the containers that will be started off the built image in Docker. The available options are listed in the [Docker Image Specification v1.2.0](https://github.com/moby/moby/blob/master/image/spec/v1.2.md#image-json-field-descriptions).

- `diskSize` is used to specify the disk size of the VM used to build the image in megabytes. By default it's 1024 MiB.

- `buildVMMemorySize` is used to specify the memory size of the VM to build the image in megabytes. By default it's 512 MiB.

After the new layer has been created, its closure (to which `contents`, `config` and `runAsRoot` contribute) will be copied in the layer itself. Only new dependencies that are not already in the existing layers will be copied.

At the end of the process, only one new single layer will be produced and added to the resulting image.

The resulting repository will only list the single image `image/tag`. In the case of [the `buildImage` example](#ex-dockerTools-buildImage), it would be `redis/latest`.

It is possible to inspect the arguments with which an image was built using its `buildArgs` attribute.

> **_NOTE:_** If you see errors similar to `getProtocolByName: does not exist (no such protocol name: tcp)` you may need to add `pkgs.iana-etc` to `contents`.

> **_NOTE:_** If you see errors similar to `Error_Protocol ("certificate has unknown CA",True,UnknownCa)` you may need to add `pkgs.cacert` to `contents`.

By default `buildImage` will use a static date of one second past the UNIX Epoch. This allows `buildImage` to produce binary reproducible images. When listing images with `docker images`, the newly created images will be listed like this:

```ShellSession
$ docker images
REPOSITORY   TAG      IMAGE ID       CREATED        SIZE
hello        latest   08c791c7846e   48 years ago   25.2MB
```

You can break binary reproducibility but have a sorted, meaningful `CREATED` column by setting `created` to `now`.

```nix
pkgs.dockerTools.buildImage {
  name = "hello";
  tag = "latest";
  created = "now";
  copyToRoot = pkgs.buildEnv {
    name = "image-root";
    paths = [ pkgs.hello ];
    pathsToLink = [ "/bin" ];
  };

  config.Cmd = [ "/bin/hello" ];
}
```

Now the Docker CLI will display a reasonable date and sort the images as expected:

```ShellSession
$ docker images
REPOSITORY   TAG      IMAGE ID       CREATED              SIZE
hello        latest   de2bf4786de6   About a minute ago   25.2MB
```

However, the produced images will not be binary reproducible.

## buildLayeredImage {#ssec-pkgs-dockerTools-buildLayeredImage}

Create a Docker image with many of the store paths being on their own layer to improve sharing between images. The image is realized into the Nix store as a gzipped tarball. Depending on the intended usage, many users might prefer to use `streamLayeredImage` instead, which this function uses internally.

`name`

: The name of the resulting image.

`tag` _optional_

: Tag of the generated image.

    *Default:* the output path's hash

`fromImage` _optional_

: The repository tarball containing the base image. It must be a valid Docker image, such as one exported by `docker save`.

    *Default:* `null`, which can be seen as equivalent to `FROM scratch` of a `Dockerfile`.

`contents` _optional_

: Top-level paths in the container. Either a single derivation, or a list of derivations.

    *Default:* `[]`

`config` _optional_

: Run-time configuration of the container. A full list of the options are available at in the [Docker Image Specification v1.2.0](https://github.com/moby/moby/blob/master/image/spec/v1.2.md#image-json-field-descriptions).

    *Default:* `{}`

`created` _optional_

: Date and time the layers were created. Follows the same `now` exception supported by `buildImage`.

    *Default:* `1970-01-01T00:00:01Z`

`maxLayers` _optional_

: Maximum number of layers to create.

    *Default:* `100`

    *Maximum:* `125`

`extraCommands` _optional_

: Shell commands to run while building the final layer, without access to most of the layer contents. Changes to this layer are "on top" of all the other layers, so can create additional directories and files.

`fakeRootCommands` _optional_

: Shell commands to run while creating the archive for the final layer in a fakeroot environment. Unlike `extraCommands`, you can run `chown` to change the owners of the files in the archive, changing fakeroot's state instead of the real filesystem. The latter would require privileges that the build user does not have. Static binaries do not interact with the fakeroot environment. By default all files in the archive will be owned by root.

`enableFakechroot` _optional_

: Whether to run in `fakeRootCommands` in `fakechroot`, making programs behave as though `/` is the root of the image being created, while files in the Nix store are available as usual. This allows scripts that perform installation in `/` to work as expected. Considering that `fakechroot` is implemented via the same mechanism as `fakeroot`, the same caveats apply.

    *Default:* `false`

### Behavior of `contents` in the final image {#dockerTools-buildLayeredImage-arg-contents}

Each path directly listed in `contents` will have a symlink in the root of the image.

For example:

```nix
pkgs.dockerTools.buildLayeredImage {
  name = "hello";
  contents = [ pkgs.hello ];
}
```

will create symlinks for all the paths in the `hello` package:

```ShellSession
/bin/hello -> /nix/store/h1zb1padqbbb7jicsvkmrym3r6snphxg-hello-2.10/bin/hello
/share/info/hello.info -> /nix/store/h1zb1padqbbb7jicsvkmrym3r6snphxg-hello-2.10/share/info/hello.info
/share/locale/bg/LC_MESSAGES/hello.mo -> /nix/store/h1zb1padqbbb7jicsvkmrym3r6snphxg-hello-2.10/share/locale/bg/LC_MESSAGES/hello.mo
```

### Automatic inclusion of `config` references {#dockerTools-buildLayeredImage-arg-config}

The closure of `config` is automatically included in the closure of the final image.

This allows you to make very simple Docker images with very little code. This container will start up and run `hello`:

```nix
pkgs.dockerTools.buildLayeredImage {
  name = "hello";
  config.Cmd = [ "${pkgs.hello}/bin/hello" ];
}
```

### Adjusting `maxLayers` {#dockerTools-buildLayeredImage-arg-maxLayers}

Increasing the `maxLayers` increases the number of layers which have a chance to be shared between different images.

Modern Docker installations support up to 128 layers, but older versions support as few as 42.

If the produced image will not be extended by other Docker builds, it is safe to set `maxLayers` to `128`. However, it will be impossible to extend the image further.

The first (`maxLayers-2`) most "popular" paths will have their own individual layers, then layer \#`maxLayers-1` will contain all the remaining "unpopular" paths, and finally layer \#`maxLayers` will contain the Image configuration.

Docker's Layers are not inherently ordered, they are content-addressable and are not explicitly layered until they are composed in to an Image.

## streamLayeredImage {#ssec-pkgs-dockerTools-streamLayeredImage}

Builds a script which, when run, will stream an uncompressed tarball of a Docker image to stdout. The arguments to this function are as for `buildLayeredImage`. This method of constructing an image does not realize the image into the Nix store, so it saves on IO and disk/cache space, particularly with large images.

The image produced by running the output script can be piped directly into `docker load`, to load it into the local docker daemon:

```ShellSession
$(nix-build) | docker load
```

Alternatively, the image be piped via `gzip` into `skopeo`, e.g., to copy it into a registry:

```ShellSession
$(nix-build) | gzip --fast | skopeo copy docker-archive:/dev/stdin docker://some_docker_registry/myimage:tag
```

## pullImage {#ssec-pkgs-dockerTools-fetchFromRegistry}

This function is analogous to the `docker pull` command, in that it can be used to pull a Docker image from a Docker registry. By default [Docker Hub](https://hub.docker.com/) is used to pull images.

Its parameters are described in the example below:

```nix
pullImage {
  imageName = "nixos/nix";
  imageDigest =
    "sha256:20d9485b25ecfd89204e843a962c1bd70e9cc6858d65d7f5fadc340246e2116b";
  finalImageName = "nix";
  finalImageTag = "1.11";
  sha256 = "0mqjy3zq2v6rrhizgb9nvhczl87lcfphq9601wcprdika2jz7qh8";
  os = "linux";
  arch = "x86_64";
}
```

- `imageName` specifies the name of the image to be downloaded, which can also include the registry namespace (e.g. `nixos`). This argument is required.

- `imageDigest` specifies the digest of the image to be downloaded. This argument is required.

- `finalImageName`, if specified, this is the name of the image to be created. Note it is never used to fetch the image since we prefer to rely on the immutable digest ID. By default it's equal to `imageName`.

- `finalImageTag`, if specified, this is the tag of the image to be created. Note it is never used to fetch the image since we prefer to rely on the immutable digest ID. By default it's `latest`.

- `sha256` is the checksum of the whole fetched image. This argument is required.

- `os`, if specified, is the operating system of the fetched image. By default it's `linux`.

- `arch`, if specified, is the cpu architecture of the fetched image. By default it's `x86_64`.

`nix-prefetch-docker` command can be used to get required image parameters:

```ShellSession
$ nix run nixpkgs.nix-prefetch-docker -c nix-prefetch-docker --image-name mysql --image-tag 5
```

Since a given `imageName` may transparently refer to a manifest list of images which support multiple architectures and/or operating systems, you can supply the `--os` and `--arch` arguments to specify exactly which image you want. By default it will match the OS and architecture of the host the command is run on.

```ShellSession
$ nix-prefetch-docker --image-name mysql --image-tag 5 --arch x86_64 --os linux
```

Desired image name and tag can be set using `--final-image-name` and `--final-image-tag` arguments:

```ShellSession
$ nix-prefetch-docker --image-name mysql --image-tag 5 --final-image-name eu.gcr.io/my-project/mysql --final-image-tag prod
```

## exportImage {#ssec-pkgs-dockerTools-exportImage}

This function is analogous to the `docker export` command, in that it can be used to flatten a Docker image that contains multiple layers. It is in fact the result of the merge of all the layers of the image. As such, the result is suitable for being imported in Docker with `docker import`.

> **_NOTE:_** Using this function requires the `kvm` device to be available.

The parameters of `exportImage` are the following:

```nix
exportImage {
  fromImage = someLayeredImage;
  fromImageName = null;
  fromImageTag = null;

  name = someLayeredImage.name;
}
```

The parameters relative to the base image have the same synopsis as described in [buildImage](#ssec-pkgs-dockerTools-buildImage), except that `fromImage` is the only required argument in this case.

The `name` argument is the name of the derivation output, which defaults to `fromImage.name`.

## shadowSetup {#ssec-pkgs-dockerTools-shadowSetup}

This constant string is a helper for setting up the base files for managing users and groups, only if such files don't exist already. It is suitable for being used in a [`buildImage` `runAsRoot`](#ex-dockerTools-buildImage-runAsRoot) script for cases like in the example below:

```nix
buildImage {
  name = "shadow-basic";

  runAsRoot = ''
    #!${pkgs.runtimeShell}
    ${pkgs.dockerTools.shadowSetup}
    groupadd -r redis
    useradd -r -g redis redis
    mkdir /data
    chown redis:redis /data
  '';
}
```

Creating base files like `/etc/passwd` or `/etc/login.defs` is necessary for shadow-utils to manipulate users and groups.

## fakeNss {#ssec-pkgs-dockerTools-fakeNss}

If your primary goal is providing a basic skeleton for user lookups to work,
and/or a lesser privileged user, adding `pkgs.fakeNss` to
the container image root might be the better choice than a custom script
running `useradd` and friends.

It provides a `/etc/passwd` and `/etc/group`, containing `root` and `nobody`
users and groups.

It also provides a `/etc/nsswitch.conf`, configuring NSS host resolution to
first check `/etc/hosts`, before checking DNS, as the default in the absence of
a config file (`dns [!UNAVAIL=return] files`) is quite unexpected.

You can pair it with `binSh`, which provides `bin/sh` as a symlink
to `bashInteractive` (as `/bin/sh` is configured as a shell).

```nix
buildImage {
  name = "shadow-basic";

  copyToRoot = pkgs.buildEnv {
    name = "image-root";
    paths = [ binSh pkgs.fakeNss ];
    pathsToLink = [ "/bin" "/etc" "/var" ];
  };
}
```
