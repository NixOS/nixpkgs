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

For packages we have `php.packages` that contains packages related
for human interaction, notable example is `php.packages.composer`.

For extensions we have `php.extensions` that contains most upstream
extensions as separate attributes as well some additional extensions
that tend to be popular, notable example is: `php.extensions.imagick`.

The different versions of PHP that nixpkgs fetch is located under
attributes named based on major and minor version number; e.g.,
`php74` is PHP 7.4 with commonly used extensions installed,
`php74base` is the same PHP runtime without extensions.

#### Installing PHP with packages

There's two majorly different parts of the PHP ecosystem in NixOS:
 - Command line utilities for human interaction. These comes from the
   `php.packages.*` attributes.
 - PHP environments with different extensions enabled. These are
   composed with `php.buildEnv` using an additional configuration file.

##### Example setup for `phpfpm`

Example to build a PHP with the extensions `imagick` and `opcache`
enabled. Then to configure it for the "foo" `phpfpm` pool:

```nix
let
  myPhp = php.buildEnv { exts = pp: with pp; [ imagick opcache ]; };
in {
  services.phpfpm.pools."foo".phpPackage = myPhp;
};
```

##### Example usage with `nix-shell`

This brings up a temporary environment that contains a PHP interpreter
with the extensions `imagick` and `opcache` enabled.

```sh
nix-shell -p 'php.buildEnv { exts = pp: with pp; [ imagick opcache ]; }'
```
