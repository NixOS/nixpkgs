# pkg-config {#sec-pkg-config}

*pkg-config* is a unified interface for declaring and querying built C/C++ libraries.

Nixpkgs provides a couple of facilities for working with this tool.

## Writing packages providing pkg-config modules {#pkg-config-writing-packages}

Packages should set `meta.pkgConfigModules` with the list of package config modules they provide.
They should also use `testers.testMetaPkgConfig` to check that the final built package matches that list.
Additionally, the [`validatePkgConfig` setup hook](https://nixos.org/manual/nixpkgs/stable/#validatepkgconfig), will do extra checks on to-be-installed pkg-config modules.

A good example of all these things is zlib:

```
{ pkg-config, testers, ... }:

stdenv.mkDerivation (finalAttrs: {
  ...

  nativeBuildInputs = [ pkg-config validatePkgConfig ];

  passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;

  meta = {
    ...
    pkgConfigModules = [ "zlib" ];
  };
})
```

## Accessing packages via pkg-config module name {#sec-pkg-config-usage}

### Within Nixpkgs {#sec-pkg-config-usage-internal}

A [setup hook](#setup-hook-pkg-config) is bundled in the `pkg-config` package to bring a derivation's declared build inputs into the environment.
This will populate environment variables like `PKG_CONFIG_PATH`, `PKG_CONFIG_PATH_FOR_BUILD`, and `PKG_CONFIG_PATH_HOST` based on:

 - how `pkg-config` itself is depended upon

 - how other dependencies are depended upon

For more details see the section on [specifying dependencies in general](#ssec-stdenv-dependencies).

Normal pkg-config commands to look up dependencies by name will then work with those environment variables defined by the hook.

### Externally {#sec-pkg-config-usage-external}

The `defaultPkgConfigPackages` package set is a set of aliases, named after the modules they provide.
This is meant to be used by language-to-nix integrations.
Hand-written packages should use the normal Nixpkgs attribute name instead.
