# PHP

## User Guide

### Using PHP

#### Overview

Several versions of PHP is available on Nix, as well as a bunch of extensions
and libraries available for each version of PHP.

The attribute `php` refers to the latest version of PHP that has undergone
sufficient testing in nixpkgs. This may not be the latest and we tend to upgrade
to the latest after branch-off for a new NixOS release so we get more testing
before the next release.

We also have an attribute called `phpbase` that contains a smaller set of default
extensions but can be extended to your liking.

We keep releases as long as they are supported for the entirety of the next
NixOS release life cycle. See [PHP Supported Versions](https://www.php.net/supported-versions.php).

As for packages we have `phpPackages` that contains a bunch of attributes where
some are suitable as extensions (notable example: `phpPackages.imagick`). And some
are more suitable for command line use (notable example: `phpPackages.composer`).

We have a special section within `phpPackages` called `phpPackages.exts` that
contain certain PHP modules that may not be part of the default PHP derivation
(example: `phpPackages.exts.opcache`).

The `phpPackages.exts.*` attributes are official extensions that originates from
the mainline PHP project while other extensions within the `phpPackages.*`
attribute is a mix of sources (such as `pecl` and other places).

The different versions of PHP that nixpkgs fetch is located under attributes
named based on major and minor version number (example: `php74` is PHP 7.4).

The same pattern with the versioning applies to the packages attribute set and
to the base attributes.

The packages attribute set for PHP 7.4 is named `php74Packages` and the attribute
for PHP 7.4 base package is named `php74base`.

#### Installing PHP with packages

There's two different kinds of things you could install:
 - A command line utility. Simply refer to it via `php*Packages.*`, and it
   automatically comes with the necessary PHP environment, certain extensions
   and libraries around it.
 - A PHP interpreter with certain extensions available.
   The `phpbase` attribute provides `phpbase.buildEnv` that allows you to wrap
   the PHP derivation with an additional config file that makes PHP import
   additional libraries or dependencies.

##### Example setup for `phpfpm`

Example to build a PHP with `imagick` and `opcache` enabled, and configure it for
the "foo" `phpfpm` pool:

```nix
let
  myPhp = phpbase.buildEnv { exts = pp: with pp; [ imagick exts.opcache ]; };
in {
  services.phpfpm.pools."foo".phpPackage = myPhp;
};
```

##### Example usage with `nix-shell`

This brings up a temporary environment that contains a PHP interpreter with
`imagick` and `opcache` enabled.

```sh
nix-shell -p 'phpbase.buildEnv { exts = pp: with pp; [ imagick exts.opcache ]; }'
```
