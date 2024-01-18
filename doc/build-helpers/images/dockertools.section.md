# pkgs.dockerTools {#sec-pkgs-dockerTools}

`pkgs.dockerTools` is a set of functions for creating and manipulating Docker images according to the [Docker Image Specification v1.3.0](https://github.com/moby/moby/blob/46f7ab808b9504d735d600e259ca0723f76fb164/image/spec/spec.md#image-json-field-descriptions).
Docker itself is not used to perform any of the operations done by these functions.

## buildImage {#ssec-pkgs-dockerTools-buildImage}

This function builds a Docker-compatible repository tarball containing a single image.
As such, the result is suitable for being loaded in Docker with `docker load` (see [](#ex-dockerTools-buildImage) for how to do this).

This function will create a single layer for all files (and dependencies) that are specified in its argument.
Only new dependencies that are not already in the existing layers will be copied.
If you prefer to create multiple layers for the files and dependencies you want to add to the image, see [](#ssec-pkgs-dockerTools-buildLayeredImage) or [](#ssec-pkgs-dockerTools-streamLayeredImage) instead.

This function allows a script to be run during the layer generation process, allowing custom behaviour to affect the final results of the image (see the documentation of the `runAsRoot` and `extraCommands` attributes).

The resulting repository tarball will list a single image as specified by the `name` and `tag` attributes.
By default, that image will use a static creation date (see documentation for the `created` attribute).
This allows `buildImage` to produce reproducible images.

:::{.tip}
When running an image built with `buildImage`, you might encounter certain errors depending on what you included in the image, especially if you did not start with any base image.

If you encounter errors similar to `getProtocolByName: does not exist (no such protocol name: tcp)`, you may need to add the contents of `pkgs.iana-etc` in the `copyToRoot` attribute.
Similarly, if you encounter errors similar to `Error_Protocol ("certificate has unknown CA",True,UnknownCa)`, you may need to add the contents of `pkgs.cacert` in the `copyToRoot` attribute.
:::

### Inputs {#ssec-pkgs-dockerTools-buildImage-inputs}

`buildImage` expects an argument with the following attributes:

`name` (String)

: The name of the generated image.

`tag` (String or Null; _optional_)

: Tag of the generated image.
  If `null`, the hash of the nix derivation will be used as the tag.

  _Default value:_ `null`.

`fromImage` (Path or Null; _optional_)

: The repository tarball of an image to be used as the base for the generated image.
  It must be a valid Docker image, such as one exported by `docker save`, or another image built with the `dockerTools` utility functions.
  This can be seen as an equivalent of `FROM fromImage` in a `Dockerfile`.
  A value of `null` can be seen as an equivalent of `FROM scratch`.

  If specified, the layer created by `buildImage` will be appended to the layers defined in the base image, resulting in an image with at least two layers (one or more layers from the base image, and the layer created by `buildImage`).
  Otherwise, the resulting image with contain the single layer created by `buildImage`.

  _Default value:_ `null`.

`fromImageName` (String or Null; _optional_)

: Used to specify the image within the repository tarball in case it contains multiple images.
  A value of `null` means that `buildImage` will use the first image available in the repository.

  :::{.note}
  This must be used with `fromImageTag`. Using only `fromImageName` without `fromImageTag` will make `buildImage` use the first image available in the repository.
  :::

  _Default value:_ `null`.

`fromImageTag` (String or Null; _optional_)

: Used to specify the image within the repository tarball in case it contains multiple images.
  A value of `null` means that `buildImage` will use the first image available in the repository.

  :::{.note}
  This must be used with `fromImageName`. Using only `fromImageTag` without `fromImageName` will make `buildImage` use the first image available in the repository
  :::

  _Default value:_ `null`.

`copyToRoot` (Path, List of Paths, or Null; _optional_)

: Files to add to the generated image.
  Anything that coerces to a path (e.g. a derivation) can also be used.
  This can be seen as an equivalent of `ADD contents/ /` in a `Dockerfile`.

  _Default value:_ `null`.

`keepContentsDirlinks` (Boolean; _optional_)

: When adding files to the generated image (as specified by `copyToRoot`), this attribute controls whether to preserve symlinks to directories.
  If `false`, the symlinks will be transformed into directories.
  This behaves the same as `rsync -k` when `keepContentsDirlinks` is `false`, and the same as `rsync -K` when `keepContentsDirlinks` is `true`.

  _Default value:_ `false`.

`runAsRoot` (String or Null; _optional_)

: A bash script that will run as root inside a VM that contains the existing layers of the base image and the new generated layer (including the files from `copyToRoot`).
  The script will be run with a working directory of `/`.
  This can be seen as an equivalent of `RUN ...` in a `Dockerfile`.
  A value of `null` means that this step in the image generation process will be skipped.

  See [](#ex-dockerTools-buildImage-runAsRoot) for how to work with this attribute.

  :::{.caution}
  Using this attribute requires the `kvm` device to be available, see [`system-features`](https://nixos.org/manual/nix/stable/command-ref/conf-file.html#conf-system-features).
  If the `kvm` device isn't available, you should consider using [`buildLayeredImage`](#ssec-pkgs-dockerTools-buildLayeredImage) or [`streamLayeredImage`](#ssec-pkgs-dockerTools-streamLayeredImage) instead.
  Those functions allow scripts to be run as root without access to the `kvm` device.
  :::

  :::{.note}
  At the time the script in `runAsRoot` is run, the files specified directly in `copyToRoot` will be present in the VM, but their dependencies might not be there yet.
  Copying their dependencies into the generated image is a step that happens after `runAsRoot` finishes running.
  :::

  _Default value:_ `null`.

`extraCommands` (String; _optional_)

: A bash script that will run before the layer created by `buildImage` is finalised.
  The script will be run on some (opaque) working directory which will become `/` once the layer is created.
  This is similar to `runAsRoot`, but the script specified in `extraCommands` is **not** run as root, and does not involve creating a VM.
  It is simply run as part of building the derivation that outputs the layer created by `buildImage`.

  See [](#ex-dockerTools-buildImage-extraCommands) for how to work with this attribute, and subtle differences compared to `runAsRoot`.

  _Default value:_ `""`.

`config` (Attribute Set; _optional_)

: Used to specify the configuration of the containers that will be started off the generated image.
  Must be an attribute set, with each attribute as listed in the [Docker Image Specification v1.3.0](https://github.com/moby/moby/blob/46f7ab808b9504d735d600e259ca0723f76fb164/image/spec/spec.md#image-json-field-descriptions).

  _Default value:_ `null`.

`architecture` (String; _optional_)

: Used to specify the image architecture.
  This is useful for multi-architecture builds that don't need cross compiling.
  If specified, its value should follow the [OCI Image Configuration Specification](https://github.com/opencontainers/image-spec/blob/main/config.md#properties), which should still be compatible with Docker.
  According to the linked specification, all possible values for `$GOARCH` in [the Go docs](https://go.dev/doc/install/source#environment) should be valid, but will commonly be one of `386`, `amd64`, `arm`, or `arm64`.

  _Default value:_ the same value from `pkgs.go.GOARCH`.

`diskSize` (Number; _optional_)

: Controls the disk size (in megabytes) of the VM used to run the script specified in `runAsRoot`.
  This attribute is ignored if `runAsRoot` is `null`.

  _Default value:_ 1024.

`buildVMMemorySize` (Number; _optional_)

: Controls the amount of memory (in megabytes) provisioned for the VM used to run the script specified in `runAsRoot`.
  This attribute is ignored if `runAsRoot` is `null`.

  _Default value:_ 512.

`created` (String; _optional_)

: Specifies the time of creation of the generated image.
  This should be either a date and time formatted according to [ISO-8601](https://en.wikipedia.org/wiki/ISO_8601) or `"now"`, in which case `buildImage` will use the current date.

  See [](#ex-dockerTools-buildImage-creatednow) for how to use `"now"`.

  :::{.caution}
  Using `"now"` means that the generated image will not be reproducible anymore (because the date will always change whenever it's built).
  :::

  _Default value:_ `"1970-01-01T00:00:01Z"`.

`uid` (Number; _optional_)

: The uid of the user that will own the files packed in the new layer built by `buildImage`.

  _Default value:_ 0.

`gid` (Number; _optional_)

: The gid of the group that will own the files packed in the new layer built by `buildImage`.

  _Default value:_ 0.

`contents` **DEPRECATED**

: This attribute is deprecated, and users are encouraged to use `copyToRoot` instead.

### Passthru outputs {#ssec-pkgs-dockerTools-buildImage-passthru-outputs}

`buildImage` defines a few [`passthru`](#var-stdenv-passthru) attributes:

`buildArgs` (Attribute Set)

: The argument passed to `buildImage` itself.
  This allows you to inspect all attributes specified in the argument, as described above.

`layer` (Attribute Set)

: The derivation with the layer created by `buildImage`.
  This allows easier inspection of the contents added by `buildImage` in the generated image.

`imageTag` (String)

: The tag of the generated image.
  This is useful if no tag was specified in the attributes of the argument to `buildImage`, because an automatic tag will be used instead.
  `imageTag` allows you to retrieve the value of the tag used in this case.

### Examples {#ssec-pkgs-dockerTools-buildImage-examples}

:::{.example #ex-dockerTools-buildImage}
# Building a Docker image

The following package builds a Docker image that runs the `redis-server` executable from the `redis` package.
The Docker image will have name `redis` and tag `latest`.

```nix
{ dockerTools, buildEnv, redis }:
dockerTools.buildImage {
  name = "redis";
  tag = "latest";

  copyToRoot = buildEnv {
    name = "image-root";
    paths = [ redis ];
    pathsToLink = [ "/bin" ];
  };

  runAsRoot = ''
    mkdir -p /data
  '';

  config = {
    Cmd = [ "/bin/redis-server" ];
    WorkingDir = "/data";
    Volumes = { "/data" = { }; };
  };
}
```

The result of building this package is a `.tar.gz` file that can be loaded into Docker:

```shell
$ nix-build
(some output removed for clarity)
building '/nix/store/yw0adm4wpsw1w6j4fb5hy25b3arr9s1v-docker-image-redis.tar.gz.drv'...
Adding layer...
tar: Removing leading `/' from member names
Adding meta...
Cooking the image...
Finished.
/nix/store/p4dsg62inh9d2ksy3c7bv58xa851dasr-docker-image-redis.tar.gz

$ docker load -i /nix/store/p4dsg62inh9d2ksy3c7bv58xa851dasr-docker-image-redis.tar.gz
(some output removed for clarity)
Loaded image: redis:latest
```
:::

:::{.example #ex-dockerTools-buildImage-runAsRoot}
# Building a Docker image with `runAsRoot`

The following package builds a Docker image with the `hello` executable from the `hello` package.
It uses `runAsRoot` to create a directory and a file inside the image.

This works the same as [](#ex-dockerTools-buildImage-extraCommands), but uses `runAsRoot` instead of `extraCommands`.

```nix
{ dockerTools, buildEnv, hello }:
dockerTools.buildImage {
  name = "hello";
  tag = "latest";

  copyToRoot = buildEnv {
    name = "image-root";
    paths = [ hello ];
    pathsToLink = [ "/bin" ];
  };

  runAsRoot = ''
    mkdir -p /data
    echo "some content" > my-file
  '';

  config = {
    Cmd = [ "/bin/hello" ];
    WorkingDir = "/data";
  };
}
```
:::

:::{.example #ex-dockerTools-buildImage-extraCommands}
# Building a Docker image with `extraCommands`

The following package builds a Docker image with the `hello` executable from the `hello` package.
It uses `extraCommands` to create a directory and a file inside the image.

This works the same as [](#ex-dockerTools-buildImage-runAsRoot), but uses `extraCommands` instead of `runAsRoot`.
Note that with `extraCommands`, we can't directly reference `/` and must create files and directories as if we were already on `/`.

```nix
{ dockerTools, buildEnv, hello }:
dockerTools.buildImage {
  name = "hello";
  tag = "latest";

  copyToRoot = buildEnv {
    name = "image-root";
    paths = [ hello ];
    pathsToLink = [ "/bin" ];
  };

  extraCommands = ''
    mkdir -p data
    echo "some content" > my-file
  '';

  config = {
    Cmd = [ "/bin/hello" ];
    WorkingDir = "/data";
  };
}
```
:::

:::{.example #ex-dockerTools-buildImage-creatednow}
# Building a Docker image with a creation date set to the current time

Note that using a value of `"now"` in the `created` attribute will break reproducibility.

```nix
{ dockerTools, buildEnv, hello }:
dockerTools.buildImage {
  name = "hello";
  tag = "latest";

  created = "now";

  copyToRoot = buildEnv {
    name = "image-root";
    paths = [ hello ];
    pathsToLink = [ "/bin" ];
  };

  config.Cmd = [ "/bin/hello" ];
}
```

After importing the generated repository tarball with Docker, its CLI will display a reasonable date and sort the images as expected:

```ShellSession
$ docker images
REPOSITORY   TAG      IMAGE ID       CREATED              SIZE
hello        latest   de2bf4786de6   About a minute ago   25.2MB
```
:::

## buildLayeredImage {#ssec-pkgs-dockerTools-buildLayeredImage}

`buildLayeredImage` uses [`streamLayeredImage`](#ssec-pkgs-dockerTools-streamLayeredImage) underneath to build a compressed Docker-compatible repository tarball.
Basically, `buildLayeredImage` runs the script created by `streamLayeredImage` to save the compressed image in the Nix store.
`buildLayeredImage` supports the same options as `streamLayeredImage`, see [`streamLayeredImage`](#ssec-pkgs-dockerTools-streamLayeredImage) for details.

:::{.note}
Despite the similar name, [`buildImage`](#ssec-pkgs-dockerTools-buildImage) works completely differently from `buildLayeredImage` and `streamLayeredImage`.

Even though some of the arguments may seem related, they cannot be interchanged.
:::

You can use this function to load an image in Docker with `docker load`.
See [](#ex-dockerTools-buildLayeredImage-hello) to see how to do that.

### Examples {#ssec-pkgs-dockerTools-buildLayeredImage-examples}

:::{.example #ex-dockerTools-buildLayeredImage-hello}
# Building a layered Docker image

The following package builds a layered Docker image that runs the `hello` executable from the `hello` package.
The Docker image will have name `hello` and tag `latest`.

```nix
{ dockerTools, hello }:
dockerTools.buildLayeredImage {
  name = "hello";
  tag = "latest";

  contents = [ hello ];

  config.Cmd = [ "/bin/hello" ];
}
```

The result of building this package is a `.tar.gz` file that can be loaded into Docker:

```shell
$ nix-build
(some output removed for clarity)
building '/nix/store/bk8bnrbw10nq7p8pvcmdr0qf57y6scha-hello.tar.gz.drv'...
No 'fromImage' provided
Creating layer 1 from paths: ['/nix/store/i93s7xxblavsacpy82zdbn4kplsyq48l-libunistring-1.1']
Creating layer 2 from paths: ['/nix/store/ji01n9vinnj22nbrb86nx8a1ssgpilx8-libidn2-2.3.4']
Creating layer 3 from paths: ['/nix/store/ldrslljw4rg026nw06gyrdwl78k77vyq-xgcc-12.3.0-libgcc']
Creating layer 4 from paths: ['/nix/store/9y8pmvk8gdwwznmkzxa6pwyah52xy3nk-glibc-2.38-27']
Creating layer 5 from paths: ['/nix/store/zhl06z4lrfrkw5rp0hnjjfrgsclzvxpm-hello-2.12.1']
Creating layer 6 with customisation...
Adding manifests...
Done.
/nix/store/hxcz7snvw7f8rzhbh6mv8jq39d992905-hello.tar.gz

$ docker load -i /nix/store/hxcz7snvw7f8rzhbh6mv8jq39d992905-hello.tar.gz
(some output removed for clarity)
Loaded image: hello:latest
```
:::

## streamLayeredImage {#ssec-pkgs-dockerTools-streamLayeredImage}

`streamLayeredImage` builds a **script** which, when run, will stream to stdout a Docker-compatible repository tarball containing a single image, using multiple layers to improve sharing between images.
This means that `streamLayeredImage` does not output an image into the Nix store, but only a script that builds the image, saving on IO and disk/cache space, particularly with large images.

You can use this function to load an image in Docker with `docker load`.
See [](#ex-dockerTools-streamLayeredImage-hello) to see how to do that.

For this function, you specify a [store path](https://nixos.org/manual/nix/stable/store/store-path) or a list of store paths to be added to the image, and the functions will automatically include any dependencies of those paths in the image.
The function will attempt to create one layer per object in the Nix store that needs to be added to the image.
In case there are more objects to include than available layers, the function will put the most ["popular"](https://github.com/NixOS/nixpkgs/tree/release-23.11/pkgs/build-support/references-by-popularity) objects in their own layers, and group all remaining objects into a single layer.

An additional layer will be created with symlinks to the store paths you specified to be included in the image.
These symlinks are built with [`symlinkJoin`](#trivial-builder-symlinkJoin), so they will be included in the root of the image.
See [](#ex-dockerTools-streamLayeredImage-exploringlayers) to understand how these symlinks are laid out in the generated image.

`streamLayeredImage` allows scripts to be run when creating the additional layer with symlinks, allowing custom behaviour to affect the final results of the image (see the documentation of the `extraCommands` and `fakeRootCommands` attributes).

The resulting repository tarball will list a single image as specified by the `name` and `tag` attributes.
By default, that image will use a static creation date (see documentation for the `created` attribute).
This allows the function to produce reproducible images.

### Inputs {#ssec-pkgs-dockerTools-streamLayeredImage-inputs}

`streamLayeredImage` expects one argument with the following attributes:

`name` (String)

: The name of the generated image.

`tag` (String; _optional_)

: Tag of the generated image.
  If `null`, the hash of the nix derivation will be used as the tag.

  _Default value:_ `null`.

`fromImage`(Path or Null; _optional_)

: The repository tarball of an image to be used as the base for the generated image.
  It must be a valid Docker image, such as one exported by `docker save`, or another image built with the `dockerTools` utility functions.
  This can be seen as an equivalent of `FROM fromImage` in a `Dockerfile`.
  A value of `null` can be seen as an equivalent of `FROM scratch`.

  If specified, the created layers will be appended to the layers defined in the base image.

  _Default value:_ `null`.

`contents` (Path or List of Paths; _optional_) []{#dockerTools-buildLayeredImage-arg-contents}

: Directories whose contents will be added to the generated image.
  Things that coerce to paths (e.g. a derivation) can also be used.
  This can be seen as an equivalent of `ADD contents/ /` in a `Dockerfile`.

  All the contents specified by `contents` will be added as a final layer in the generated image.
  They will be added as links to the actual files (e.g. links to the store paths).
  The actual files will be added in previous layers.

  _Default value:_ `[]`

`config` (Attribute Set; _optional_) []{#dockerTools-buildLayeredImage-arg-config}

: Used to specify the configuration of the containers that will be started off the generated image.
  Must be an attribute set, with each attribute as listed in the [Docker Image Specification v1.3.0](https://github.com/moby/moby/blob/46f7ab808b9504d735d600e259ca0723f76fb164/image/spec/spec.md#image-json-field-descriptions).

  If any packages are used directly in `config`, they will be automatically included in the generated image.
  See [](#ex-dockerTools-streamLayeredImage-configclosure) for an example.

  _Default value:_ `null`.

`architecture` (String; _optional_)

: Used to specify the image architecture.
  This is useful for multi-architecture builds that don't need cross compiling.
  If specified, its value should follow the [OCI Image Configuration Specification](https://github.com/opencontainers/image-spec/blob/main/config.md#properties), which should still be compatible with Docker.
  According to the linked specification, all possible values for `$GOARCH` in [the Go docs](https://go.dev/doc/install/source#environment) should be valid, but will commonly be one of `386`, `amd64`, `arm`, or `arm64`.

  _Default value:_ the same value from `pkgs.go.GOARCH`.

`created` (String; _optional_)

: Specifies the time of creation of the generated image.
  This should be either a date and time formatted according to [ISO-8601](https://en.wikipedia.org/wiki/ISO_8601) or `"now"`, in which case the current date will be used.

  :::{.caution}
  Using `"now"` means that the generated image will not be reproducible anymore (because the date will always change whenever it's built).
  :::

  _Default value:_ `"1970-01-01T00:00:01Z"`.

`maxLayers` (Number; _optional_) []{#dockerTools-buildLayeredImage-arg-maxLayers}

: The maximum number of layers that will be used by the generated image.
  If a `fromImage` was specified, the number of layers used by `fromImage` will be subtracted from `maxLayers` to ensure that the image generated will have at most `maxLayers`.

  :::{.caution}
  Depending on the tool/runtime where the image will be used, there might be a limit to the number of layers that an image can have.
  For Docker, see [this issue on GitHub](https://github.com/docker/docs/issues/8230).
  :::

  _Default value:_ 100.

`extraCommands` (String; _optional_)

: A bash script that will run in the context of the layer created with the contents specified by `contents`.
  At the moment this script runs, only the contents directly specified by `contents` will be available as links.

  _Default value:_ `""`.

`fakeRootCommands` (String; _optional_)

: A bash script that will run in the context of the layer created with the contents specified by `contents`.
  During the process to generate that layer, the script in `extraCommands` will be run first, if specified.
  After that, a {manpage}`fakeroot(1)` environment will be entered.
  The script specified in `fakeRootCommands` runs inside the fakeroot environment, and the layer is then generated from the view of the files inside the fakeroot environment.

  This is useful to change the owners of the files in the layer (by running `chown`, for example), or performing any other privileged operations related to file manipulation (by default, all files in the layer will be owned by root, and the build environment doesn't have enough privileges to directly perform privileged operations on these files).

  For more details, see the manpage for {manpage}`fakeroot(1)`.

  :::{.caution}
  Due to how fakeroot works, static binaries cannot perform privileged file operations in `fakeRootCommands`, unless `enableFakechroot` is set to `true`.
  :::

  _Default value:_ `""`.

`enableFakechroot` (Boolean; _optional_)

: By default, the script specified in `fakeRootCommands` only runs inside a fakeroot environment.
  If `enableFakechroot` is `true`, a more complete chroot environment will be created using [`proot`](https://proot-me.github.io/) before running the script in `fakeRootCommands`.
  Files in the Nix store will be available.
  This allows scripts that perform installation in `/` to work as expected.
  This can be seen as an equivalent of `RUN ...` in a `Dockerfile`.

  _Default value:_ `false`

`includeStorePaths` (Boolean; _optional_)

: The files specified in `contents` are put into layers in the generated image.
  If `includeStorePaths` is `false`, the actual files will not be included in the generated image, and only links to them will be added instead.
  It is **not recommended** to set this to `false` unless you have other tooling to insert the store paths via other means (such as bind mounting the host store) when running containers with the generated image.
  If you don't provide any extra tooling, the generated image won't run properly.

  See [](#ex-dockerTools-streamLayeredImage-exploringlayers) to understand the impact of setting `includeStorePaths` to `false`.

  _Default value:_ `true`

`passthru` (Attribute Set; _optional_)

: Use this to pass any attributes as [passthru](#var-stdenv-passthru) for the resulting derivation.

  _Default value:_ `{}`

### Passthru outputs {#ssec-pkgs-dockerTools-streamLayeredImage-passthru-outputs}

`streamLayeredImage` also defines its own [`passthru`](#var-stdenv-passthru) attributes:

`imageTag` (String)

: The tag of the generated image.
  This is useful if no tag was specified in the attributes of the argument to the function, because an automatic tag will be used instead.
  `imageTag` allows you to retrieve the value of the tag used in this case.

### Examples {#ssec-pkgs-dockerTools-streamLayeredImage-examples}

:::{.example #ex-dockerTools-streamLayeredImage-hello}
# Streaming a layered Docker image

The following package builds a **script** which, when run, will stream a layered Docker image that runs the `hello` executable from the `hello` package.
The Docker image will have name `hello` and tag `latest`.

```nix
{ dockerTools, hello }:
dockerTools.streamLayeredImage {
  name = "hello";
  tag = "latest";

  contents = [ hello ];

  config.Cmd = [ "/bin/hello" ];
}
```

The result of building this package is a script.
Running this script and piping it into `docker load` gives you the same image that was built in [](#ex-dockerTools-buildLayeredImage-hello).
Note that in this case, the image is never added to the Nix store, but instead streamed directly into Docker.

```shell
$ nix-build
(output removed for clarity)
/nix/store/wsz2xl8ckxnlb769irvq6jv1280dfvxd-stream-hello

$ /nix/store/wsz2xl8ckxnlb769irvq6jv1280dfvxd-stream-hello | docker load
No 'fromImage' provided
Creating layer 1 from paths: ['/nix/store/i93s7xxblavsacpy82zdbn4kplsyq48l-libunistring-1.1']
Creating layer 2 from paths: ['/nix/store/ji01n9vinnj22nbrb86nx8a1ssgpilx8-libidn2-2.3.4']
Creating layer 3 from paths: ['/nix/store/ldrslljw4rg026nw06gyrdwl78k77vyq-xgcc-12.3.0-libgcc']
Creating layer 4 from paths: ['/nix/store/9y8pmvk8gdwwznmkzxa6pwyah52xy3nk-glibc-2.38-27']
Creating layer 5 from paths: ['/nix/store/zhl06z4lrfrkw5rp0hnjjfrgsclzvxpm-hello-2.12.1']
Creating layer 6 with customisation...
Adding manifests...
Done.
(some output removed for clarity)
Loaded image: hello:latest
```
:::

:::{.example #ex-dockerTools-streamLayeredImage-exploringlayers}
# Exploring the layers in an image built with `streamLayeredImage`

Assume the following package, which builds a layered Docker image with the `hello` package.

```nix
{ dockerTools, hello }:
dockerTools.streamLayeredImage {
  name = "hello";
  contents = [ hello ];
}
```

The `hello` package depends on 4 other packages:

```shell
$ nix-store --query -R $(nix-build -A hello)
/nix/store/i93s7xxblavsacpy82zdbn4kplsyq48l-libunistring-1.1
/nix/store/ji01n9vinnj22nbrb86nx8a1ssgpilx8-libidn2-2.3.4
/nix/store/ldrslljw4rg026nw06gyrdwl78k77vyq-xgcc-12.3.0-libgcc
/nix/store/9y8pmvk8gdwwznmkzxa6pwyah52xy3nk-glibc-2.38-27
/nix/store/zhl06z4lrfrkw5rp0hnjjfrgsclzvxpm-hello-2.12.1
```

This means that all these packages will be included in the image generated by `streamLayeredImage`.
It will put each package in its own layer, for a total of 5 layers with actual files in them.
A final layer will be created only with symlinks for the `hello` package.

The image generated will have the following directory structure (some directories were collapsed for readability):

```
├── bin
│   └── hello → /nix/store/zhl06z4lrfrkw5rp0hnjjfrgsclzvxpm-hello-2.12.1/bin/hello
├── nix
│   └── store
│       ├─⊕ 9y8pmvk8gdwwznmkzxa6pwyah52xy3nk-glibc-2.38-27
│       ├─⊕ i93s7xxblavsacpy82zdbn4kplsyq48l-libunistring-1.1
│       ├─⊕ ji01n9vinnj22nbrb86nx8a1ssgpilx8-libidn2-2.3.4
│       ├─⊕ ldrslljw4rg026nw06gyrdwl78k77vyq-xgcc-12.3.0-libgcc
│       └─⊕ zhl06z4lrfrkw5rp0hnjjfrgsclzvxpm-hello-2.12.1
└── share
    ├── info
    │   └── hello.info → /nix/store/zhl06z4lrfrkw5rp0hnjjfrgsclzvxpm-hello-2.12.1/share/info/hello.info
    ├─⊕ locale
    └── man
        └── man1
            └── hello.1.gz → /nix/store/zhl06z4lrfrkw5rp0hnjjfrgsclzvxpm-hello-2.12.1/share/man/man1/hello.1.gz
```

Each of the packages in `/nix/store` comes from a layer in the image.
The final layer adds the `/bin` and `/share` directories, but they only contain links to the actual files in `/nix/store`.

If our package sets `includeStorePaths` to `false`, we'll end up with only the final layer with the links, but the actual files won't exist in the image:

```nix
{ dockerTools, hello }:
dockerTools.streamLayeredImage {
  name = "hello";
  contents = [ hello ];
}
```

After building this package, the image will have the following directory structure:

```
├── bin
│   └── hello → /nix/store/zhl06z4lrfrkw5rp0hnjjfrgsclzvxpm-hello-2.12.1/bin/hello
└── share
    ├── info
    │   └── hello.info → /nix/store/zhl06z4lrfrkw5rp0hnjjfrgsclzvxpm-hello-2.12.1/share/info/hello.info
    ├─⊕ locale
    └── man
        └── man1
            └── hello.1.gz → /nix/store/zhl06z4lrfrkw5rp0hnjjfrgsclzvxpm-hello-2.12.1/share/man/man1/hello.1.gz
```

Note how the links point to paths in `/nix/store`, but they're not included in the image itself.
This is why you need extra tooling when using `includeStorePaths`:
a container created from such image won't find any of the files it needs to run otherwise.
:::

::: {.example #ex-dockerTools-streamLayeredImage-configclosure}
# Building a layered Docker image with packages directly in `config`

The closure of `config` is automatically included in the generated image.
The following package shows a more compact way to create the same output generated in [](#ex-dockerTools-streamLayeredImage-hello).

```nix
{ dockerTools, hello, lib }:
dockerTools.streamLayeredImage {
  name = "hello";
  tag = "latest";
  config.Cmd = [ "${lib.getExe hello}" ];
}
```
:::

## pullImage {#ssec-pkgs-dockerTools-fetchFromRegistry}

This function is analogous to the `docker pull` command, in that it can be used to pull a Docker image from a Docker registry. By default [Docker Hub](https://hub.docker.com/) is used to pull images.

Its parameters are described in the example below:

```nix
pullImage {
  imageName = "nixos/nix";
  imageDigest =
    "sha256:473a2b527958665554806aea24d0131bacec46d23af09fef4598eeab331850fa";
  finalImageName = "nix";
  finalImageTag = "2.11.1";
  sha256 = "sha256-qvhj+Hlmviz+KEBVmsyPIzTB3QlVAFzwAY1zDPIBGxc=";
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
$ nix run nixpkgs#nix-prefetch-docker -- --image-name mysql --image-tag 5
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

## Environment Helpers {#ssec-pkgs-dockerTools-helpers}

Some packages expect certain files to be available globally.
When building an image from scratch (i.e. without `fromImage`), these files are missing.
`pkgs.dockerTools` provides some helpers to set up an environment with the necessary files.
You can include them in `copyToRoot` like this:

```nix
buildImage {
  name = "environment-example";
  copyToRoot = with pkgs.dockerTools; [
    usrBinEnv
    binSh
    caCertificates
    fakeNss
  ];
}
```

### usrBinEnv {#sssec-pkgs-dockerTools-helpers-usrBinEnv}

This provides the `env` utility at `/usr/bin/env`.

### binSh {#sssec-pkgs-dockerTools-helpers-binSh}

This provides `bashInteractive` at `/bin/sh`.

### caCertificates {#sssec-pkgs-dockerTools-helpers-caCertificates}

This sets up `/etc/ssl/certs/ca-certificates.crt`.

### fakeNss {#sssec-pkgs-dockerTools-helpers-fakeNss}

Provides `/etc/passwd` and `/etc/group` that contain root and nobody.
Useful when packaging binaries that insist on using nss to look up
username/groups (like nginx).

### shadowSetup {#ssec-pkgs-dockerTools-shadowSetup}

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

## buildNixShellImage {#ssec-pkgs-dockerTools-buildNixShellImage}

Create a Docker image that sets up an environment similar to that of running `nix-shell` on a derivation.
When run in Docker, this environment somewhat resembles the Nix sandbox typically used by `nix-build`, with a major difference being that access to the internet is allowed.
It additionally also behaves like an interactive `nix-shell`, running things like `shellHook` and setting an interactive prompt.
If the derivation is fully buildable (i.e. `nix-build` can be used on it), running `buildDerivation` inside such a Docker image will build the derivation, with all its outputs being available in the correct `/nix/store` paths, pointed to by the respective environment variables like `$out`, etc.

::: {.warning}
The behavior doesn't match `nix-shell` or `nix-build` exactly and this function is known not to work correctly for e.g. fixed-output derivations, content-addressed derivations, impure derivations and other special types of derivations.
:::

### Arguments {#ssec-pkgs-dockerTools-buildNixShellImage-arguments}

`drv`

: The derivation on which to base the Docker image.

    Adding packages to the Docker image is possible by e.g. extending the list of `nativeBuildInputs` of this derivation like

    ```nix
    buildNixShellImage {
      drv = someDrv.overrideAttrs (old: {
        nativeBuildInputs = old.nativeBuildInputs or [] ++ [
          somethingExtra
        ];
      });
      # ...
    }
    ```

    Similarly, you can extend the image initialization script by extending `shellHook`

`name` _optional_

: The name of the resulting image.

    *Default:* `drv.name + "-env"`

`tag` _optional_

: Tag of the generated image.

    *Default:* the resulting image derivation output path's hash

`uid`/`gid` _optional_

: The user/group ID to run the container as. This is like a `nixbld` build user.

    *Default:* 1000/1000

`homeDirectory` _optional_

: The home directory of the user the container is running as

    *Default:* `/build`

`shell` _optional_

: The path to the `bash` binary to use as the shell. This shell is started when running the image.

    *Default:* `pkgs.bashInteractive + "/bin/bash"`

`command` _optional_

: Run this command in the environment of the derivation, in an interactive shell. See the `--command` option in the [`nix-shell` documentation](https://nixos.org/manual/nix/stable/command-ref/nix-shell.html?highlight=nix-shell#options).

    *Default:* (none)

`run` _optional_

: Same as `command`, but runs the command in a non-interactive shell instead. See the `--run` option in the [`nix-shell` documentation](https://nixos.org/manual/nix/stable/command-ref/nix-shell.html?highlight=nix-shell#options).

    *Default:* (none)

### Example {#ssec-pkgs-dockerTools-buildNixShellImage-example}

The following shows how to build the `pkgs.hello` package inside a Docker container built with `buildNixShellImage`.

```nix
with import <nixpkgs> {};
dockerTools.buildNixShellImage {
  drv = hello;
}
```

Build the derivation:

```console
nix-build hello.nix
```

    these 8 derivations will be built:
      /nix/store/xmw3a5ln29rdalavcxk1w3m4zb2n7kk6-nix-shell-rc.drv
    ...
    Creating layer 56 from paths: ['/nix/store/crpnj8ssz0va2q0p5ibv9i6k6n52gcya-stdenv-linux']
    Creating layer 57 with customisation...
    Adding manifests...
    Done.
    /nix/store/cpyn1lc897ghx0rhr2xy49jvyn52bazv-hello-2.12-env.tar.gz

Load the image:

```console
docker load -i result
```

    0d9f4c4cd109: Loading layer [==================================================>]   2.56MB/2.56MB
    ...
    ab1d897c0697: Loading layer [==================================================>]  10.24kB/10.24kB
    Loaded image: hello-2.12-env:pgj9h98nal555415faa43vsydg161bdz

Run the container:

```console
docker run -it hello-2.12-env:pgj9h98nal555415faa43vsydg161bdz
```

    [nix-shell:/build]$

In the running container, run the build:

```console
buildDerivation
```

    unpacking sources
    unpacking source archive /nix/store/8nqv6kshb3vs5q5bs2k600xpj5bkavkc-hello-2.12.tar.gz
    ...
    patching script interpreter paths in /nix/store/z5wwy5nagzy15gag42vv61c2agdpz2f2-hello-2.12
    checking for references to /build/ in /nix/store/z5wwy5nagzy15gag42vv61c2agdpz2f2-hello-2.12...

Check the build result:

```console
$out/bin/hello
```

    Hello, world!
