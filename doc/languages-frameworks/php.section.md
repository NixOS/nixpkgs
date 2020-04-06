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

The different versions of PHP that nixpkgs provides is located under
attributes named based on major and minor version number; e.g.,
`php74` is PHP 7.4 with commonly used extensions installed,
`php74base` is the same PHP runtime without extensions.

#### Installing PHP with packages

A PHP package with specific extensions enabled can be built using
`php.withExtensions`. This is a function which accepts an anonymous
function as its only argument; the function should take one argument,
the set of all extensions, and return a list of wanted extensions. For
example, a PHP package with the opcache and ImageMagick extensions
enabled:

```nix
php.withExtensions (e: with e; [ imagick opcache ])
```

Note that this will give you a package with _only_ opcache and
ImageMagick, none of the other extensions which are enabled by default
in the `php` package will be available.

To enable building on a previous PHP package, the currently enabled
extensions are made available in its `enabledExtensions`
attribute. For example, to generate a package with all default
extensions enabled, except opcache, but with ImageMagick:

```nix
php.withExtensions (e:
  (lib.filter (e: e != php.extensions.opcache) php.enabledExtensions)
  ++ [ e.imagick ])
```

If you want a PHP build with extra configuration in the `php.ini`
file, you can use `php.buildEnv`. This function takes two named and
optional parameters: `extensions` and `extraConfig`. `extensions`
takes an extension specification equivalent to that of
`php.withExtensions`, `extraConfig` a string of additional `php.ini`
configuration parameters. For example, a PHP package with the opcache
and ImageMagick extensions enabled, and `memory_limit` set to `256M`:

```nix
php.buildEnv {
  extensions = e: with e; [ imagick opcache ];
  extraConfig = "memory_limit=256M";
}
```

##### Example setup for `phpfpm`

You can use the previous examples in a `phpfpm` pool called `foo` as
follows:

```nix
let
  myPhp = php.withExtensions (e: with e; [ imagick opcache ]);
in {
  services.phpfpm.pools."foo".phpPackage = myPhp;
};
```

```nix
let
  myPhp = php.buildEnv {
    extensions = e: with e; [ imagick opcache ];
    extraConfig = "memory_limit=256M";
  };
in {
  services.phpfpm.pools."foo".phpPackage = myPhp;
};
```

##### Example usage with `nix-shell`

This brings up a temporary environment that contains a PHP interpreter
with the extensions `imagick` and `opcache` enabled.

```sh
nix-shell -p 'php.buildEnv { extensions = e: with e; [ imagick opcache ]; }'
```
