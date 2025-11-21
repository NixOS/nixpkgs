# Global configuration {#chap-packageconfig}

Nix comes with certain defaults about which packages can and cannot be installed, based on a package's metadata.
By default, Nix will prevent installation if any of the following criteria are true:

-   The package is thought to be broken, and has had its `meta.broken` set to `true`.

-   The package isn't intended to run on the given system, as none of its `meta.platforms` match the given system.

-   The package's `meta.license` is set to a license which is considered to be unfree.

-   The package has known security vulnerabilities but has not or can not be updated for some reason, and a list of issues has been entered into the package's `meta.knownVulnerabilities`.

Each of these criteria can be altered in the Nixpkgs configuration.

:::{.note}
All this is checked during evaluation already, and the check includes any package that is evaluated.
In particular, all build-time dependencies are checked.
:::

A user's Nixpkgs configuration is stored in a user-specific configuration file located at `~/.config/nixpkgs/config.nix`. For example:

```nix
{ allowUnfree = true; }
```

:::{.caution}
Unfree software is not tested or built in Nixpkgs continuous integration, and therefore not cached.
Most unfree licenses prohibit either executing or distributing the software.
:::

## Installing broken packages {#sec-allow-broken}

There are several ways to try compiling a package which has been marked as broken.

-   For allowing the build of a broken package once, you can use an environment variable for a single invocation of the nix tools:

    ```ShellSession
    $ export NIXPKGS_ALLOW_BROKEN=1
    ```

-   For permanently allowing broken packages that match some condition to be built, you may add `allowBrokenPredicate` to your user's configuration file with the desired condition, for example:

    ```nix
    {
      allowBrokenPredicate = pkg: builtins.elem (pkgs.lib.getName pkg) [ "hello" ];
    }
    ```

-   For permanently allowing all broken packages to be built, you may add `allowBroken = true;` to your user's configuration file, like this:

    ```nix
    { allowBroken = true; }
    ```


## Installing packages on unsupported systems {#sec-allow-unsupported-system}

There are also two ways to try compiling a package which has been marked as unsupported for the given system.

-   For allowing the build of an unsupported package once, you can use an environment variable for a single invocation of the nix tools:

    ```ShellSession
    $ export NIXPKGS_ALLOW_UNSUPPORTED_SYSTEM=1
    ```

-   For permanently allowing unsupported packages to be built, you may add `allowUnsupportedSystem = true;` to your user's configuration file, like this:

    ```nix
    { allowUnsupportedSystem = true; }
    ```

The difference between a package being unsupported on some system and being broken is admittedly a bit fuzzy. If a program *ought* to work on a certain platform, but doesn't, the platform should be included in `meta.platforms`, but marked as broken with e.g.  `meta.broken = !hostPlatform.isWindows`. Of course, this begs the question of what "ought" means exactly. That is left to the package maintainer.

## Installing unfree packages {#sec-allow-unfree}

All users of Nixpkgs are free software users, and many users (and developers) of Nixpkgs want to limit and tightly control their exposure to unfree software.
At the same time, many users need (or want) to run some specific pieces of proprietary software.
Nixpkgs includes some expressions for unfree software packages.
By default unfree software cannot be installed and doesn’t show up in searches.

There are several ways to tweak how Nix handles a package which has been marked as unfree.

-   To temporarily allow all unfree packages, you can use an environment variable for a single invocation of the nix tools:

    ```ShellSession
    $ export NIXPKGS_ALLOW_UNFREE=1
    ```

-   It is possible to permanently allow individual unfree packages, while still blocking unfree packages by default using the `allowUnfreePredicate` configuration option in the user configuration file.

    This option is a function which accepts a package as a parameter, and returns a boolean. The following example configuration accepts a package and always returns false:

    ```nix
    { allowUnfreePredicate = (pkg: false); }
    ```

    For a more useful example, try the following. This configuration only allows unfree packages named roon-server and Visual Studio Code:

    ```nix
    {
      allowUnfreePredicate =
        pkg:
        builtins.elem (lib.getName pkg) [
          "roon-server"
          "vscode"
        ];
    }
    ```

-   It is also possible to allow and block licenses that are specifically acceptable or not acceptable, using `allowlistedLicenses` and `blocklistedLicenses`, respectively.

    The following example configuration allowlists the licenses `amd` and `wtfpl`:

    ```nix
    {
      allowlistedLicenses = with lib.licenses; [
        amd
        wtfpl
      ];
    }
    ```

    The following example configuration blocklists the `gpl3Only` and `agpl3Only` licenses:

    ```nix
    {
      blocklistedLicenses = with lib.licenses; [
        agpl3Only
        gpl3Only
      ];
    }
    ```

    Note that `allowlistedLicenses` only applies to unfree licenses unless `allowUnfree` is enabled. It is not a generic allowlist for all types of licenses. `blocklistedLicenses` applies to all licenses.

A complete list of licenses can be found in the file `lib/licenses.nix` of the nixpkgs tree.

## Installing insecure packages {#sec-allow-insecure}

There are several ways to tweak how Nix handles a package which has been marked as insecure.

-   To temporarily allow all insecure packages, you can use an environment variable for a single invocation of the nix tools:

    ```ShellSession
    $ export NIXPKGS_ALLOW_INSECURE=1
    ```

-   It is possible to permanently allow individual insecure packages, while still blocking other insecure packages by default using the `permittedInsecurePackages` configuration option in the user configuration file.

    The following example configuration permits the installation of the hypothetically insecure package `hello`, version `1.2.3`:

    ```nix
    { permittedInsecurePackages = [ "hello-1.2.3" ]; }
    ```

-   It is also possible to create a custom policy around which insecure packages to allow and deny, by overriding the `allowInsecurePredicate` configuration option.

    The `allowInsecurePredicate` option is a function which accepts a package and returns a boolean, much like `allowUnfreePredicate`.

    The following configuration example allows any version of the `ovftool` package:

    ```nix
    { allowInsecurePredicate = pkg: builtins.elem (lib.getName pkg) [ "ovftool" ]; }
    ```

    Note that `permittedInsecurePackages` is only checked if `allowInsecurePredicate` is not specified.

## Modify packages via `packageOverrides` {#sec-modify-via-packageOverrides}

You can define a function called `packageOverrides` in your local `~/.config/nixpkgs/config.nix` to override Nix packages. It must be a function that takes pkgs as an argument and returns a modified set of packages.

```nix
{
  packageOverrides = pkgs: rec {
    foo = pkgs.foo.override {
      # ...
    };
  };
}
```

## `config` Options Reference {#sec-config-options-reference}

The following attributes can be passed in [`config`](#chap-packageconfig).

```{=include=} options
id-prefix: opt-
list-id: configuration-variable-list
source: ../config-options.json
```


## Declarative Package Management {#sec-declarative-package-management}

### Build an environment {#sec-building-environment}

Using `packageOverrides`, it is possible to manage packages declaratively. This means that we can list all of our desired packages within a declarative Nix expression. For example, to have `aspell`, `bc`, `ffmpeg`, `coreutils`, `gdb`, `nix`, `emscripten`, `jq`, `nox`, and `silver-searcher`, we could use the following in `~/.config/nixpkgs/config.nix`:

```nix
{
  packageOverrides =
    pkgs: with pkgs; {
      myPackages = pkgs.buildEnv {
        name = "my-packages";
        paths = [
          aspell
          bc
          coreutils
          gdb
          ffmpeg
          nix
          emscripten
          jq
          nox
          silver-searcher
        ];
      };
    };
}
```

To install it into our environment, you can just run `nix-env -iA nixpkgs.myPackages`. If you want to load the packages to be built from a working copy of `nixpkgs` you just run `nix-env -f. -iA myPackages`. To explore what's been installed, just look through `~/.nix-profile/`. You can see that a lot of stuff has been installed. Some of this stuff is useful some of it isn't. Let's tell Nixpkgs to only link the stuff that we want:

```nix
{
  packageOverrides =
    pkgs: with pkgs; {
      myPackages = pkgs.buildEnv {
        name = "my-packages";
        paths = [
          aspell
          bc
          coreutils
          gdb
          ffmpeg
          nix
          emscripten
          jq
          nox
          silver-searcher
        ];
        pathsToLink = [
          "/share"
          "/bin"
        ];
      };
    };
}
```

`pathsToLink` tells Nixpkgs to only link the paths listed which gets rid of the extra stuff in the profile. `/bin` and `/share` are good defaults for a user environment, getting rid of the clutter. If you are running on Nix on macOS, you may want to add another path as well, `/Applications`, that makes GUI apps available.

### Getting documentation {#sec-getting-documentation}

After building that new environment, look through `~/.nix-profile` to make sure everything is there that we wanted. Discerning readers will note that some files are missing. Look inside `~/.nix-profile/share/man/man1/` to verify this. There are no man pages for any of the Nix tools! This is because some packages like Nix have multiple outputs for things like documentation (see section 4). Let's make Nix install those as well.

```nix
{
  packageOverrides =
    pkgs: with pkgs; {
      myPackages = pkgs.buildEnv {
        name = "my-packages";
        paths = [
          aspell
          bc
          coreutils
          ffmpeg
          nix
          emscripten
          jq
          nox
          silver-searcher
        ];
        pathsToLink = [
          "/share/man"
          "/share/doc"
          "/bin"
        ];
        extraOutputsToInstall = [
          "man"
          "doc"
        ];
      };
    };
}
```

This provides us with some useful documentation for using our packages.  However, if we actually want those manpages to be detected by man, we need to set up our environment. This can also be managed within Nix expressions.

```nix
{
  packageOverrides = pkgs: {
    myProfile = pkgs.writeText "my-profile" ''
      export PATH=$HOME/.nix-profile/bin:/nix/var/nix/profiles/default/bin:/sbin:/bin:/usr/sbin:/usr/bin
      export MANPATH=$HOME/.nix-profile/share/man:/nix/var/nix/profiles/default/share/man:/usr/share/man
    '';
    myPackages = pkgs.buildEnv {
      name = "my-packages";
      paths = with pkgs; [
        (runCommand "profile" { } ''
          mkdir -p $out/etc/profile.d
          cp ${myProfile} $out/etc/profile.d/my-profile.sh
        '')
        aspell
        bc
        coreutils
        ffmpeg
        man
        nix
        emscripten
        jq
        nox
        silver-searcher
      ];
      pathsToLink = [
        "/share/man"
        "/share/doc"
        "/bin"
        "/etc"
      ];
      extraOutputsToInstall = [
        "man"
        "doc"
      ];
    };
  };
}
```

For this to work fully, you must also have this script sourced when you are logged in. Try adding something like this to your `~/.profile` file:

```ShellSession
#!/bin/sh
if [ -d "${HOME}/.nix-profile/etc/profile.d" ]; then
  for i in "${HOME}/.nix-profile/etc/profile.d/"*.sh; do
    if [ -r "$i" ]; then
      . "$i"
    fi
  done
fi
```

Now just run `. "${HOME}/.profile"` and you can start loading man pages from your environment.

### GNU info setup {#sec-gnu-info-setup}

Configuring GNU info is a little bit trickier than man pages. To work correctly, info needs a database to be generated. This can be done with some small modifications to our environment scripts.

```nix
{
  packageOverrides = pkgs: {
    myProfile = pkgs.writeText "my-profile" ''
      export PATH=$HOME/.nix-profile/bin:/nix/var/nix/profiles/default/bin:/sbin:/bin:/usr/sbin:/usr/bin
      export MANPATH=$HOME/.nix-profile/share/man:/nix/var/nix/profiles/default/share/man:/usr/share/man
      export INFOPATH=$HOME/.nix-profile/share/info:/nix/var/nix/profiles/default/share/info:/usr/share/info
    '';
    myPackages = pkgs.buildEnv {
      name = "my-packages";
      paths = with pkgs; [
        (runCommand "profile" { } ''
          mkdir -p $out/etc/profile.d
          cp ${myProfile} $out/etc/profile.d/my-profile.sh
        '')
        aspell
        bc
        coreutils
        ffmpeg
        man
        nix
        emscripten
        jq
        nox
        silver-searcher
        texinfoInteractive
      ];
      pathsToLink = [
        "/share/man"
        "/share/doc"
        "/share/info"
        "/bin"
        "/etc"
      ];
      extraOutputsToInstall = [
        "man"
        "doc"
        "info"
      ];
      postBuild = ''
        if [ -x $out/bin/install-info -a -w $out/share/info ]; then
          shopt -s nullglob
          for i in $out/share/info/*.info $out/share/info/*.info.gz; do
              $out/bin/install-info $i $out/share/info/dir
          done
        fi
      '';
    };
  };
}
```

`postBuild` tells Nixpkgs to run a command after building the environment. In this case, `install-info` adds the installed info pages to `dir` which is GNU info's default root node. Note that `texinfoInteractive` is added to the environment to give the `install-info` command.
