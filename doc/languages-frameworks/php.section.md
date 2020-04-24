# PHP

## User Guide

### Using PHP

#### Overview

Several versions of PHP are available on Nix, each of which having a
wide variety of extensions and libraries available.

The attribute `php` refers to the version of PHP considered most
stable and thoroughly tested in nixpkgs for any given release of
NixOS. Note that while this version of PHP may not be the latest major
release from upstream, any version of PHP supported in nixpkgs may be
utilized by specifying the desired attribute by version, such as
`php74`.

Only versions of PHP that are supported by upstream for the entirety
of a given NixOS release will be included in that release of
NixOS. See [PHP Supported
Versions](https://www.php.net/supported-versions.php).

Interactive tools built on PHP are put in `php.packages`; composer is
for example available at `php.packages.composer`.

Most extensions that come with PHP, as well as some popular
third-party ones, are available in `php.extensions`; for example, the
opcache extension shipped with PHP is available at
`php.extensions.opcache` and the third-party ImageMagick extension at
`php.extensions.imagick`.

The different versions of PHP that nixpkgs provides are located under
attributes named based on major and minor version number; e.g.,
`php74` is PHP 7.4 with commonly used extensions installed,
`php74base` is the same PHP runtime without extensions.

#### Installing PHP with packages

A PHP package with specific extensions enabled can be built using
`php.withExtensions`. This is a function which accepts an anonymous
function as its only argument; the function should accept two named
parameters: `enabled` - a list of currently enabled extensions and
`all` - the set of all extensions, and return a list of wanted
extensions. For example, a PHP package with all default extensions and
ImageMagick enabled:

```nix
php.withExtensions ({ enabled, all }:
  enabled ++ [ all.imagick ])
```

To exclude some, but not all, of the default extensions, you can
filter the `enabled` list like this:

```nix
php.withExtensions ({ enabled, all }:
  (lib.filter (e: e != php.extensions.opcache) enabled)
  ++ [ all.imagick ])
```

To build your list of extensions from the ground up, you can simply
ignore `enabled`:

```nix
php.withExtensions ({ all, ... }: with all; [ opcache imagick ])
```

`php.withExtensions` provides extensions by wrapping a minimal php
base package, providing a `php.ini` file listing all extensions to be
loaded. You can access this package through the `php.unwrappedPhp`
attribute; useful if you, for example, need access to the `dev`
output. The generated `php.ini` file can be accessed through the
`php.phpIni` attribute.

If you want a PHP build with extra configuration in the `php.ini`
file, you can use `php.buildEnv`. This function takes two named and
optional parameters: `extensions` and `extraConfig`. `extensions`
takes an extension specification equivalent to that of
`php.withExtensions`, `extraConfig` a string of additional `php.ini`
configuration parameters. For example, a PHP package with the opcache
and ImageMagick extensions enabled, and `memory_limit` set to `256M`:

```nix
php.buildEnv {
  extensions = { all, ... }: with all; [ imagick opcache ];
  extraConfig = "memory_limit=256M";
}
```

##### Example setup for `phpfpm`

You can use the previous examples in a `phpfpm` pool called `foo` as
follows:

```nix
let
  myPhp = php.withExtensions ({ all, ... }: with all; [ opcache imagick ]);
in {
  services.phpfpm.pools."foo".phpPackage = myPhp;
};
```

```nix
let
  myPhp = php.buildEnv {
    extensions = { all, ... }: with all; [ imagick opcache ];
    extraConfig = "memory_limit=256M";
  };
in {
  services.phpfpm.pools."foo".phpPackage = myPhp;
};
```

##### Example usage with `nix-shell`

This brings up a temporary environment that contains a PHP interpreter
with the extensions `imagick` and `opcache` enabled:

```sh
nix-shell -p 'php.withExtensions ({ all, ... }: with all; [ imagick opcache ])'
```
