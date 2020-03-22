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

As for packages we have `php.packages` that contains a bunch of
attributes where some are suitable as extensions (notable example:
`php.packages.imagick`). And some are more suitable for command
line use (notable example: `php.packages.composer`).

We have a special section within `php.packages` called
`php.packages.exts` that contain certain PHP modules that may not
be part of the default PHP derivation (example:
`php.packages.exts.opcache`).

The `php.packages.exts.*` attributes are official extensions which
originate from the mainline PHP project, while other extensions within
the `php.packages.*` attribute are of mixed origin (such as `pecl`
and other places).

The different versions of PHP that nixpkgs fetch is located under
attributes named based on major and minor version number; e.g.,
`php74` is PHP 7.4 with commonly used extensions installed,
`php74base` is the same PHP runtime without extensions.

#### Installing PHP with packages

There's two different kinds of things you could install:
 - A command line utility. Simply refer to it via
   `php*.packages.*`, and it automatically comes with the necessary
   PHP environment, certain extensions and libraries around it.
 - A PHP interpreter with certain extensions available.  The `php`
   attribute provides `php.buildEnv` that allows you to wrap the PHP
   derivation with an additional config file that makes PHP import
   additional libraries or dependencies.

##### Example setup for `phpfpm`

Example to build a PHP with `imagick` and `opcache` enabled, and
configure it for the "foo" `phpfpm` pool:

```nix
let
  myPhp = php.buildEnv { exts = pp: with pp; [ imagick exts.opcache ]; };
in {
  services.phpfpm.pools."foo".phpPackage = myPhp;
};
```

##### Example usage with `nix-shell`

This brings up a temporary environment that contains a PHP interpreter
with `imagick` and `opcache` enabled.

```sh
nix-shell -p 'php.buildEnv { exts = pp: with pp; [ imagick exts.opcache ]; }'
```
