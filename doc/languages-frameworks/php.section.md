# PHP {#sec-php}

## User Guide {#ssec-php-user-guide}

### Overview {#ssec-php-user-guide-overview}

Several versions of PHP are available on Nix, each of which having a
wide variety of extensions and libraries available.

The different versions of PHP that nixpkgs provides are located under
attributes named based on major and minor version number; e.g.,
`php81` is PHP 8.1.

Only versions of PHP that are supported by upstream for the entirety
of a given NixOS release will be included in that release of
NixOS. See [PHP Supported
Versions](https://www.php.net/supported-versions.php).

The attribute `php` refers to the version of PHP considered most
stable and thoroughly tested in nixpkgs for any given release of
NixOS - not necessarily the latest major release from upstream.

All available PHP attributes are wrappers around their respective
binary PHP package and provide commonly used extensions this way. The
real PHP 7.4 package, i.e. the unwrapped one, is available as
`php81.unwrapped`; see the next section for more details.

Interactive tools built on PHP are put in `php.packages`; composer is
for example available at `php.packages.composer`.

Most extensions that come with PHP, as well as some popular
third-party ones, are available in `php.extensions`; for example, the
opcache extension shipped with PHP is available at
`php.extensions.opcache` and the third-party ImageMagick extension at
`php.extensions.imagick`.

### Installing PHP with extensions {#ssec-php-user-guide-installing-with-extensions}

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
php.withExtensions ({ all, ... }: with all; [ imagick opcache ])
```

`php.withExtensions` provides extensions by wrapping a minimal php
base package, providing a `php.ini` file listing all extensions to be
loaded. You can access this package through the `php.unwrapped`
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

#### Example setup for `phpfpm` {#ssec-php-user-guide-installing-with-extensions-phpfpm}

You can use the previous examples in a `phpfpm` pool called `foo` as
follows:

```nix
let
  myPhp = php.withExtensions ({ all, ... }: with all; [ imagick opcache ]);
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

#### Example usage with `nix-shell` {#ssec-php-user-guide-installing-with-extensions-nix-shell}

This brings up a temporary environment that contains a PHP interpreter
with the extensions `imagick` and `opcache` enabled:

```sh
nix-shell -p 'php.withExtensions ({ all, ... }: with all; [ imagick opcache ])'
```

### Installing PHP packages with extensions {#ssec-php-user-guide-installing-packages-with-extensions}

All interactive tools use the PHP package you get them from, so all
packages at `php.packages.*` use the `php` package with its default
extensions. Sometimes this default set of extensions isn't enough and
you may want to extend it. A common case of this is the `composer`
package: a project may depend on certain extensions and `composer`
won't work with that project unless those extensions are loaded.

Example of building `composer` with additional extensions:
```nix
(php.withExtensions ({ all, enabled }:
  enabled ++ (with all; [ imagick redis ]))
).packages.composer
```

### Overriding PHP packages {#ssec-php-user-guide-overriding-packages}

`php-packages.nix` form a scope, allowing us to override the packages defined within. For example, to apply a patch to a `mysqlnd` extension, you can simply pass an overlay-style function to `php`’s `packageOverrides` argument:

```nix
php.override {
  packageOverrides = final: prev: {
    extensions = prev.extensions // {
      mysqlnd = prev.extensions.mysqlnd.overrideAttrs (attrs: {
        patches = attrs.patches or [] ++ [
          …
        ];
      });
    };
  };
}
```
