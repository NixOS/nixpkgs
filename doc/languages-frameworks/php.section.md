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
real PHP 8.1 package, i.e. the unwrapped one, is available as
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

`php-packages.nix` form a scope, allowing us to override the packages defined
within. For example, to apply a patch to a `mysqlnd` extension, you can simply
pass an overlay-style function to `php`’s `packageOverrides` argument:

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

### Building PHP projects {#ssec-building-php-projects}

With [Composer](https://getcomposer.org/), you can effectively build PHP
projects by streamlining dependency management. As the de-facto standard
dependency manager for PHP, Composer enables you to declare and manage the
libraries your project relies on, ensuring a more organized and efficient
development process.

Composer is not a package manager in the same sense as `Yum` or `Apt` are. Yes,
it deals with "packages" or libraries, but it manages them on a per-project
basis, installing them in a directory (e.g. `vendor`) inside your project. By
default, it does not install anything globally. This idea is not new and
Composer is strongly inspired by node's `npm` and ruby's `bundler`.

Currently, there is no other PHP tool that offers the same functionality as
Composer. Consequently, incorporating a helper in Nix to facilitate building
such applications is a logical choice.

In a Composer project, dependencies are defined in a `composer.json` file,
while their specific versions are locked in a `composer.lock` file. Some
Composer-based projects opt to include this `composer.lock` file in their source
code, while others choose not to.

In Nix, there are multiple approaches to building a Composer-based project.

One such method is the `php.buildComposerProject` helper function, which serves
as a wrapper around `mkDerivation`.

Using this function, you can build a PHP project that includes both a
`composer.json` and `composer.lock` file. If the project specifies binaries
using the `bin` attribute in `composer.json`, these binaries will be
automatically linked and made accessible in the derivation. In this context,
"binaries" refer to PHP scripts that are intended to be executable.

To use the helper effectively, simply add the `vendorHash` attribute, which
enables the wrapper to handle the heavy lifting.

Internally, the helper operates in three stages:

1. It constructs a `composerRepository` attribute derivation by creating a
   composer repository on the filesystem containing dependencies specified in
   `composer.json`. This process uses the function
   `php.mkComposerRepository` which in turn uses the
   `php.composerHooks.composerRepositoryHook` hook. Internaly this function uses
   a custom
   [Composer plugin](https://github.com/nix-community/composer-local-repo-plugin) to
   generate the repository.
2. The resulting `composerRepository` derivation is then used by the
   `php.composerHooks.composerInstallHook` hook, which is responsible for
   creating the final `vendor` directory.
3. Any "binary" specified in the `composer.json` are linked and made accessible
   in the derivation.

As the autoloader optimization can be activated directly within the
`composer.json` file, we do not enable any autoloader optimization flags.

To customize the PHP version, you can specify the `php` attribute. Similarly, if
you wish to modify the Composer version, use the `composer` attribute. It is
important to note that both attributes should be of the `derivation` type.

Here's an example of working code example using `php.buildComposerProject`:

```nix
{ php, fetchFromGitHub }:

php.buildComposerProject (finalAttrs: {
  pname = "php-app";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "git-owner";
    repo = "git-repo";
    rev = finalAttrs.version;
    hash = "sha256-VcQRSss2dssfkJ+iUb5qT+FJ10GHiFDzySigcmuVI+8=";
  };

  # PHP version containing the `ast` extension enabled
  php = php.buildEnv {
    extensions = ({ enabled, all }: enabled ++ (with all; [
      ast
    ]));
  };

  # The composer vendor hash
  vendorHash = "sha256-86s/F+/5cBAwBqZ2yaGRM5rTGLmou5//aLRK5SA0WiQ=";

  # If the composer.lock file is missing from the repository, add it:
  # composerLock = ./path/to/composer.lock;
})
```

In case the file `composer.lock` is missing from the repository, it is possible
to specify it using the `composerLock` attribute.

The other method is to use all these methods and hooks individually. This has
the advantage of building a PHP library within another derivation very easily
when necessary.

Here's a working code example to build a PHP library using `mkDerivation` and
separate functions and hooks:

```nix
{ stdenvNoCC, fetchFromGitHub, php }:

stdenvNoCC.mkDerivation (finalAttrs:
let
  src = fetchFromGitHub {
    owner = "git-owner";
    repo = "git-repo";
    rev = finalAttrs.version;
    hash = "sha256-VcQRSss2dssfkJ+iUb5qT+FJ10GHiFDzySigcmuVI+8=";
  };
in {
  inherit src;
  pname = "php-app";
  version = "1.0.0";

  buildInputs = [ php ];

  nativeBuildInputs = [
    php.packages.composer
    # This hook will use the attribute `composerRepository`
    php.composerHooks.composerInstallHook
  ];

  composerRepository = php.mkComposerRepository {
    inherit (finalAttrs) src;
    # Specifying a custom composer.lock since it is not present in the sources.
    composerLock = ./composer.lock;
    # The composer vendor hash
    vendorHash = "sha256-86s/F+/5cBAwBqZ2yaGRM5rTGLmou5//aLRK5SA0WiQ=";
  };
})
```
