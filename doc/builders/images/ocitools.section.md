# pkgs.ociTools {#sec-pkgs-ociTools}

`pkgs.ociTools` is a set of functions for creating containers according to the [OCI container specification v1.0.0](https://github.com/opencontainers/runtime-spec). Beyond that, it makes no assumptions about the container runner you choose to use to run the created container.

## buildContainer {#ssec-pkgs-ociTools-buildContainer}

This function creates a simple OCI container that runs a single command inside of it. An OCI container consists of a `config.json` and a rootfs directory. The nix store of the container will contain all referenced dependencies of the given command.

The parameters of `buildContainer` with an example value are described below:

```nix
buildContainer {
  args = [
    (with pkgs;
      writeScript "run.sh" ''
        #!${bash}/bin/bash
        exec ${bash}/bin/bash
      '').outPath
  ];

  mounts = {
    "/data" = {
      type = "none";
      source = "/var/lib/mydata";
      options = [ "bind" ];
    };
  };

  readonly = false;
}
```

- `args` specifies a set of arguments to run inside the container. This is the only required argument for `buildContainer`. All referenced packages inside the derivation will be made available inside the container.

- `mounts` specifies additional mount points chosen by the user. By default only a minimal set of necessary filesystems are mounted into the container (e.g procfs, cgroupfs)

- `readonly` makes the container\'s rootfs read-only if it is set to true. The default value is false `false`.
