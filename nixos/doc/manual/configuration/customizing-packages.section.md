# Customising Packages {#sec-customising-packages}

In Nix, packages are usually referred to as `pkgs.git`. This expression can be extended to allow modification of the package. For example, instead of `pkgs.git` you can also use `(pkgs.git.override { guiSupport = true; })`. This results in a new package where support for Git GUI is enabled. When using this expression, a package is built that includes the `git-gui` binary.

The Nixpkgs manual has information about modifying existing packages by overriding. See [the chapter on overriding](https://nixos.org/manual/nixpkgs/stable/#chap-overrides) to know more.

Here we will focus on the ways to use those modified packages in NixOS. We describe 3 methods:

* [System environment](#system-environment) for executable packages available system-wide
* [package options in NixOS modules](#package-options-in-nix-os-modules) for background services and programs
* [Nixpkgs overlays](#nixpkgs-overlays) for in-place package replacements and additions

## System environment (#system-environment)

Using a custom package in `environment.systemPackages` will only change the system environment. Basically, it'll allow you to change the packages that you'd use in your terminal, but not anything else.

Changing:

```nix
{
  environment.systemPackages = [
    pkgs.git
  ];
}
```

To:

```nix
{
  environment.systemPackages = [
    (pkgs.git.override { guiSupport = true; })
  ];
}
```

will allow you to use the Git GUI tools (`git-gui`) in your terminal. It _doesn't_ alter packages or NixOS modules that _depend_ on Git. This is an important distinction, as it only affects the environment (applications available in `PATH`) and doesn't rebuild any other packages.

## Package options in NixOS modules (#package-options-in-nix-os-modules)

Some packages are only used in background services, so you won't interact with them directly. In NixOS these are often configured with `services.*.enable` options.

These options usually also have an option to change the package for the service, named `services.*.package`.

For example, pipewire is a service to handle audio and video streams on a system. It is enabled on NixOS using:

```nix
{
  services.pipewire.enable = true;
}
```

To override the pipewire package being used, the following option can be added:

```nix
{
  services.pipewire.package = pkgs.pipewire.override { x11Support = false; };
}
```

In this case `pipewire` is compiled without x11 support. The resulting package is used as the pipewire background service, which will be configured by NixOS in systemd.

Just like with `systemPackages`, the altered package is only used in the NixOS system and packages that depend on pipewire will still refer to the original pipewire package.

## Nixpkgs overlays (#nixpkgs-overlays)

Overlays in Nix allow extending Nixpkgs. Like the name suggests, it overlays your package definitions on top of Nixpkgs. Usually this means that you can alter what packages are available in the `pkgs` variable, allowing you to add or overwrite packages.

With overlays you can replace an existing package system-wide. That means overwriting an existing package with your own will not only change your system, but can also change all packages that depend on the original package.

This can be useful when you want to for instance patch a library that is used by other software. It does however require all depending packages to be rebuild. Nix does these rebuilds seamlessly and automatically, but it does cost time.

Also a word of warning: overlays can become confusing. You generally want to be aware of overwritten packages in overlays. It is not obvious when referring to a package `pkgs.git` that it is different from what is in Nixpkgs. This can become especially confusing when overwriting packages like `openssl`, which `git` and many other packages depends on. With great power comes great responsibility!

On NixOS you can use [the `nixpkgs.overlays` option](https://search.nixos.org/options?show=nixpkgs.overlays&query=nixpkgs.overlays):

```nix
{
  nixpkgs.overlays = [
    (final: prev: {
      pipewire = prev.pipewire.override { x11Support = false; };
    })
  ];
}
```

When creating such an overlay, it is not needed anymore to specify the override in `systemPackages` nor `services.*.package`, as `pkgs.pipewire` will only refer to this overridden package.

Note that the overlay is defined as a function with the arguments `final` and `prev`.

`prev` refers to the previous layer, the underlying one. In this case that is `nixpkgs`. We take the original package from `nixpkgs` using `prev.pipewire` and alter that package. With `pipewire = ...;` we overwrite the orignal pipewire package in succeeding layers, which eventually results in the change in `pkgs`.

`final` refers to the top-level overlay, which includes our overwritten packages. If we want to refer to a another package that we have overridden, then we can refer to `final`.

More information about overlays can be found in [the Nixpkgs manual](https://nixos.org/manual/nixpkgs/stable/#chap-overlays).

It is also possible to introduce a new attribute for custom packages, so that you can refer to this attribute in other parts of your configuration. For instance:

```nix
{
  nixpkgs.overlays = [
    (final: prev: {
      git-with-gui = prev.git.override { guiSupport = true; };
    })
  ];
}
```

will allow referring to `pkgs.git-with-gui` where-ever you have access to pkgs. For instance in NixOS:

```nix
{
  environment.systemPackages = [ pkgs.git-with-gui ];
}
```

Or even in Nix CLI:

```sh
nix-env -iA git-with-gui
```

Note that even though we have a new attribute name in the above example, the _name of the package_ didn't change. The name is part of the derivation. The package is called `git`, so the Nix store path is still `/nix/store/*-git`. When using `.override` this part of the derivation would not change. The name can only be changed using `.overrideAttrs`.

## Common use-cases (#use-cases)

With the above knowledge we can tackle a number of common use-cases.

### Use different version of a package in NixOS

```nix
{
  services.xserver.windowManager.i3.package = pkgs.i3.overrideAttrs (previousAttrs: {
    name = "i3-next";
    src = pkgs.fetchFromGitHub {
      owner = "i3";
      repo = "i3";
      rev = "81287743869a5bdec4ffc0c1e6d1f8fd33920bcb";
      hash = pkgs.lib.fakeHash;
    };
  });
}
```

This overrides the `i3` package with a version based on https://github.com/i3/i3/commit/81287743869a5bdec4ffc0c1e6d1f8fd33920bcb. `pkgs.lib.fakeHash` is a placeholder for the actual hash of the retrieved directory. Upon building Nix will ask to replace it with the actual hash that Nix calculated.

The `name = "i3-next"` is also set. This is to make sure the new package name doesn't equal the original package name (`i3-X.X.X`).

### Use local source code for a package

```nix
{
  environment.systemPackages = [ pkgs.myfortune ];

  nixpkgs.overlays = [
    (final: prev: {
      myfortune = prev.fortune.overrideAttrs (previousAttrs: {
        src = ./fortune-src;
      });
    })
  ];
}
```

This creates a new attribute `myfortune` that uses the build steps from `fortune` to build source code from a local directory `./fortune-src` into a package. It makes the package available through `environment.systemPackages`, so that it is available in the terminal.

### Use a different dependency for a single package

```nix
{
  nixpkgs.overlays = [
    (final: prev: {
      maven-jdk8 = prev.maven.override {
        jdk = final.jdk8;
      };
    })
  ];
}
```

This creates a new attribute `maven-jdk8` that builds and runs maven explicitly under `jdk8`. Notice that `final.jdk8` is used, so that other overlays may potentially overwrite `jdk8`. Also note that `final.maven` is _not_ used, because that would refer to this package, causing an infinite loop during Nix evaluation.

### Apply a security patch system-wide

```nix
{
  nixpkgs.overlays = [
    (final: prev: {
      openssl = prev.openssl.overrideAttrs (previousAttrs: {
        patches = previousAttrs.patches ++ [
          (fetchpatch {
            name = "CVE-2021-4044.patch";
            url = "https://git.openssl.org/gitweb/?p=openssl.git;a=patch;h=758754966791c537ea95241438454aa86f91f256";
            hash = pkgs.lib.fakeHash;
          })
        ];
      });
    })
  ];
}
```

This overwrites `openssl` with a patched version. The patch itself is fetched from OpenSSL's own git repository. Overwriting `openssl` in an overlay will rebuild and test all packages that depend on OpenSSL as well, so in this case can lead to high build times.
