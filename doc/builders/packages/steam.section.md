# Steam {#sec-steam}

## Steam in Nix {#sec-steam-nix}

Steam is distributed as a `.deb` file, for now only as an i686 package (the amd64 package only has documentation). When unpacked, it has a script called `steam` that in Ubuntu (their target distro) would go to `/usr/bin`. When run for the first time, this script copies some files to the user's home, which include another script that is the ultimate responsible for launching the steam binary, which is also in \$HOME.

Nix problems and constraints:

- We don't have `/bin/bash` and many scripts point there. Similarly for `/usr/bin/python`.
- We don't have the dynamic loader in `/lib`.
- The `steam.sh` script in \$HOME can not be patched, as it is checked and rewritten by steam.
- The steam binary cannot be patched, it's also checked.

The current approach to deploy Steam in NixOS is composing a FHS-compatible chroot environment, as documented [here](http://sandervanderburg.blogspot.nl/2013/09/composing-fhs-compatible-chroot.html). This allows us to have binaries in the expected paths without disrupting the system, and to avoid patching them to work in a non FHS environment.

## How to play {#sec-steam-play}

Use `programs.steam.enable = true;` if you want to add steam to systemPackages and also enable a few workarrounds aswell as Steam controller support or other Steam supported controllers such as the DualShock 4 or Nintendo Switch Pr.

## Troubleshooting {#sec-steam-troub}

- **Steam fails to start. What do I do?**
  Try to run

  ```ShellSession
  strace steam
  ```

  to see what is causing steam to fail.

- **Using the FOSS Radeon or nouveau (nvidia) drivers**

  - The `newStdcpp` parameter was removed since NixOS 17.09 and should not be needed anymore.
  - Steam ships statically linked with a version of libcrypto that conflics with the one dynamically loaded by radeonsi_dri.so. If you get the error
    ```
    steam.sh: line 713: 7842 Segmentation fault (core dumped)
    ```
    have a look at [this pull request](https://github.com/NixOS/nixpkgs/pull/20269).

- **Java**

  1. There is no java in steam chrootenv by default. If you get a message like

  ```
  /home/foo/.local/share/Steam/SteamApps/common/towns/towns.sh: line 1: java: command not found
  ```

  You need to add

  ```nix
  steam.override { withJava = true; };
  ```

## steam-run {#sec-steam-run}

The FHS-compatible chroot used for steam can also be used to run other linux games that expect a FHS environment. To do it, add

```nix
pkgs.steam.override ({
          nativeOnly = true;
          newStdcpp = true;
        }).run
```

to your configuration, rebuild, and run the game with

```
steam-run ./foo
```
