# buildFHSEnv {#sec-fhs-environments}

`buildFHSEnv` provides a way to build and run FHS-compatible lightweight sandboxes. It creates an isolated root filesystem with the host's `/nix/store`, so its footprint in terms of disk space is quite small. This allows you to run software which is hard or unfeasible to patch for NixOS; 3rd-party source trees with FHS assumptions, games distributed as tarballs, software with integrity checking and/or external self-updated binaries for instance.
It uses Linux' namespaces feature to create temporary lightweight environments which are destroyed after all child processes exit, without requiring elevated privileges. It works similar to containerisation technology such as Docker or FlatPak but provides no security-relevant separation from the host system.

Accepted arguments are:

- `name`
        The name of the environment and the wrapper executable.
- `targetPkgs`
        Packages to be installed for the main host's architecture (i.e. x86_64 on x86_64 installations). Along with libraries binaries are also installed.
- `multiPkgs`
        Packages to be installed for all architectures supported by a host (i.e. i686 and x86_64 on x86_64 installations). Only libraries are installed by default.
- `multiArch`
        Whether to install 32bit multiPkgs into the FHSEnv in 64bit environments
- `extraBuildCommands`
        Additional commands to be executed for finalizing the directory structure.
- `extraBuildCommandsMulti`
        Like `extraBuildCommands`, but executed only on multilib architectures.
- `extraOutputsToInstall`
        Additional derivation outputs to be linked for both target and multi-architecture packages.
- `extraInstallCommands`
        Additional commands to be executed for finalizing the derivation with runner script.
- `runScript`
        A shell command to be executed inside the sandbox. It defaults to `bash`. Command line arguments passed to the resulting wrapper are appended to this command by default.
        This command must be escaped; i.e. `"foo app" --do-stuff --with "some file"`. See `lib.escapeShellArgs`.
- `profile`
        Optional script for `/etc/profile` within the sandbox.

You can create a simple environment using a `shell.nix` like this:

```nix
{ pkgs ? import <nixpkgs> {} }:

(pkgs.buildFHSEnv {
  name = "simple-x11-env";
  targetPkgs = pkgs: (with pkgs; [
    udev
    alsa-lib
  ]) ++ (with pkgs.xorg; [
    libX11
    libXcursor
    libXrandr
  ]);
  multiPkgs = pkgs: (with pkgs; [
    udev
    alsa-lib
  ]);
  runScript = "bash";
}).env
```

Running `nix-shell` on it would drop you into a shell inside an FHS env where those libraries and binaries are available in FHS-compliant paths. Applications that expect an FHS structure (i.e. proprietary binaries) can run inside this environment without modification.
You can build a wrapper by running your binary in `runScript`, e.g. `./bin/start.sh`. Relative paths work as expected.

Additionally, the FHS builder links all relocated gsettings-schemas (the glib setup-hook moves them to `share/gsettings-schemas/${name}/glib-2.0/schemas`) to their standard FHS location. This means you don't need to wrap binaries with `wrapGAppsHook`.
