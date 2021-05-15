# buildFHSUserEnv {#sec-fhs-environments}

`buildFHSUserEnv` provides a way to build and run FHS-compatible lightweight sandboxes. It creates an isolated root with bound `/nix/store`, so its footprint in terms of disk space needed is quite small. This allows one to run software which is hard or unfeasible to patch for NixOS -- 3rd-party source trees with FHS assumptions, games distributed as tarballs, software with integrity checking and/or external self-updated binaries. It uses Linux namespaces feature to create temporary lightweight environments which are destroyed after all child processes exit, without root user rights requirement. Accepted arguments are:

- `name`
        Environment name.
- `targetPkgs`
        Packages to be installed for the main host's architecture (i.e. x86_64 on x86_64 installations). Along with libraries binaries are also installed.
- `multiPkgs`
        Packages to be installed for all architectures supported by a host (i.e. i686 and x86_64 on x86_64 installations). Only libraries are installed by default.
- `extraBuildCommands`
        Additional commands to be executed for finalizing the directory structure.
- `extraBuildCommandsMulti`
        Like `extraBuildCommands`, but executed only on multilib architectures.
- `extraOutputsToInstall`
        Additional derivation outputs to be linked for both target and multi-architecture packages.
- `extraInstallCommands`
        Additional commands to be executed for finalizing the derivation with runner script.
- `runScript`
        A command that would be executed inside the sandbox and passed all the command line arguments. It defaults to `bash`.

One can create a simple environment using a `shell.nix` like that:

```nix
{ pkgs ? import <nixpkgs> {} }:

(pkgs.buildFHSUserEnv {
  name = "simple-x11-env";
  targetPkgs = pkgs: (with pkgs;
    [ udev
      alsaLib
    ]) ++ (with pkgs.xorg;
    [ libX11
      libXcursor
      libXrandr
    ]);
  multiPkgs = pkgs: (with pkgs;
    [ udev
      alsaLib
    ]);
  runScript = "bash";
}).env
```

Running `nix-shell` would then drop you into a shell with these libraries and binaries available. You can use this to run closed-source applications which expect FHS structure without hassles: simply change `runScript` to the application path, e.g. `./bin/start.sh` -- relative paths are supported.
